//
//  Terminal.m
//  iSH
//
//  Created by Theodore Dubois on 10/18/17.
//

#import "Terminal.h"
#include "fs/devices.h"
#include "fs/tty.h"
#include "fs/devices.h"

extern struct tty_driver ios_pty_driver;

typedef struct tty *tty_t;

@interface Terminal () <WKScriptMessageHandler> {
    lock_t _dataLock;
    cond_t _dataConsumed;
}

@property BOOL loaded;
@property (nonatomic) tty_t tty;
// lock with dataLock for !linux and @synchronized(self) for linux
@property (nonatomic) NSMutableData *pendingData;
// sending output is an asynchronous thing due to javascript, this is used to ensure it doesn't happen twice at once
@property (nonatomic) BOOL outputInProgress;

//@property DelayedUITask *refreshTask;
//@property DelayedUITask *scrollToBottomTask;

@property BOOL applicationCursor;

@property NSNumber *terminalsKey;
@property NSUUID *uuid;

@property NSTimer *mytimer;

@end

@interface CustomWebView : WKWebView
@end
@implementation CustomWebView
- (BOOL)becomeFirstResponder {
    if (@available(iOS 13.4, *)) {
        return [super becomeFirstResponder];
    }
    return NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:) || action == @selector(paste:)) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}
@end

@implementation Terminal
@synthesize webView = _webView;

static const int BUF_SIZE = 1<<14;

static NSMapTable<NSNumber *, Terminal *> *terminals;
static NSMapTable<NSUUID *, Terminal *> *terminalsByUUID;

- (instancetype)initWithType:(int)type number:(int)num {
    @synchronized (Terminal.class) {
        self.terminalsKey = @(dev_make(type, num));
        Terminal *terminal = [terminals objectForKey:self.terminalsKey];
        if (terminal)
            return terminal;
        
        if (self = [super init]) {
            self.pendingData = [[NSMutableData alloc] initWithCapacity:BUF_SIZE];
//            self.refreshTask = [[DelayedUITask alloc] initWithTarget:self action:@selector(refresh)];
            //            self.scrollToBottomTask = [[DelayedUITask alloc] initWithTarget:self action:@selector(scrollToBottom)];
            lock_init(&_dataLock);
            cond_init(&_dataConsumed);
            
            [terminals setObject:self forKey:self.terminalsKey];
            self.uuid = [NSUUID UUID];
            [terminalsByUUID setObject:self forKey:self.uuid];
        }
        return self;
    }
}

- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        [config.userContentController addScriptMessageHandler:self name:@"load"];
        [config.userContentController addScriptMessageHandler:self name:@"log"];
        [config.userContentController addScriptMessageHandler:self name:@"sendInput"];
        [config.userContentController addScriptMessageHandler:self name:@"resize"];
        [config.userContentController addScriptMessageHandler:self name:@"propUpdate"];
        // Make the web view really big so that if a program tries to write to the terminal before it's displayed, the text probably won't wrap too badly.
        CGRect webviewSize = CGRectMake(0, 0, 10000, 10000);
        _webView = [[CustomWebView alloc] initWithFrame:webviewSize configuration:config];
        _webView.scrollView.scrollEnabled = NO;
        NSURL *xtermHtmlFile = [NSBundle.mainBundle URLForResource:@"term" withExtension:@"html"];
        [_webView loadFileURL:xtermHtmlFile allowingReadAccessToURL:xtermHtmlFile];
    }
    return _webView;
}

+ (Terminal *)createPseudoTerminal:(struct tty **)tty {
    *tty = pty_open_fake(&ios_pty_driver);
    if (IS_ERR(*tty))
        return nil;
    return (__bridge Terminal *) (*tty)->data;
}

- (void)setTty:(tty_t)tty {
    @synchronized (self) {
        _tty = tty;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self syncWindowSize];
    });
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"load"]) {
        self.loaded = YES;
        //        [self.refreshTask schedule];
        // make sure this setting works if it's set before loading
        self.enableVoiceOverAnnounce = self.enableVoiceOverAnnounce;
    } else if ([message.name isEqualToString:@"log"]) {
        NSLog(@"%@", message.body);
    } else if ([message.name isEqualToString:@"sendInput"]) {
        NSData *data = [message.body dataUsingEncoding:NSUTF8StringEncoding];
        [self sendInput:data];
    } else if ([message.name isEqualToString:@"resize"]) {
        [self syncWindowSize];
    } else if ([message.name isEqualToString:@"propUpdate"]) {
        [self setValue:message.body[1] forKey:message.body[0]];
    }
}

- (void)syncWindowSize {
    [self.webView evaluateJavaScript:@"exports.getSize()" completionHandler:^(NSArray<NSNumber *> *dimensions, NSError *error) {
        int cols = dimensions[0].intValue;
        int rows = dimensions[1].intValue;
        if (self.tty == NULL)
            return;
        lock(&self.tty->lock);
        tty_set_winsize(self.tty, (struct winsize_) {.col = cols, .row = rows});
        unlock(&self.tty->lock);
    }];
}

- (void)setEnableVoiceOverAnnounce:(BOOL)enableVoiceOverAnnounce {
    _enableVoiceOverAnnounce = enableVoiceOverAnnounce;
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"term.setAccessibilityEnabled(%@)",
                                      enableVoiceOverAnnounce ? @"true" : @"false"]
                   completionHandler:nil];
}

- (int)sendOutput:(const void *)buf length:(int)len {
    lock(&_dataLock);
    if (!NSThread.isMainThread) {
        // The main thread is the only one that can unblock this, so sleeping here would be a deadlock.
        // The only reason for this to be called on the main thread is if input is echoed.
        while (_pendingData.length > BUF_SIZE)
            wait_for_ignore_signals(&_dataConsumed, &_dataLock, NULL);
    }
    [_pendingData appendData:[NSData dataWithBytes:buf length:len]];
    
//    [self.refreshTask schedule];
    
    if (!self.mytimer.valid) {
        self.mytimer = [NSTimer timerWithTimeInterval:1./60 repeats:NO block:^(NSTimer * _Nonnull timer) {
            self.mytimer = nil;
            ((void (*)(id, SEL)) [self methodForSelector:@selector(refresh)])(self, @selector(refresh));
        }];
        [NSRunLoop.mainRunLoop addTimer:self.mytimer forMode:NSDefaultRunLoopMode];
    }
        
    unlock(&_dataLock);
    return len;
}

- (void)sendInput:(NSData *)input {
    if (self.tty == NULL)
        return;
    tty_input(self.tty, input.bytes, input.length, 0);
    [self.webView evaluateJavaScript:@"exports.setUserGesture()" completionHandler:nil];
    //    [self.scrollToBottomTask schedule];
}

- (void)scrollToBottom {
    [self.webView evaluateJavaScript:@"exports.scrollToBottom()" completionHandler:nil];
}

- (NSString *)arrow:(char)direction {
    return [NSString stringWithFormat:@"\x1b%c%c", self.applicationCursor ? 'O' : '[', direction];
}

//- (NSString *)arrowLeft {
//    NSString *str = [NSString stringWithFormat:@"\x1b%c%c", self.applicationCursor ? 'O' : '[', 'D'];
//    NSLog(@"com.gg.mysh.log: str: %@", str);
//    return str;
//}

- (void)refresh {
    if (!self.loaded)
        return;
    
    lock(&_dataLock);
    if (_outputInProgress) {
//        [self.refreshTask schedule];
        unlock(&_dataLock);
        return;
    }
    NSData *data = _pendingData;
    _pendingData = [[NSMutableData alloc] initWithCapacity:BUF_SIZE];
    _outputInProgress = YES;
    notify(&self->_dataConsumed);
    unlock(&_dataLock);
    
    NSString *dataString = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSISOLatin1StringEncoding];
    // escape for javascript. only have to worry about the first 256 codepoints, because of the latin-1 encoding.
    dataString = [dataString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *jsToEvaluate = [NSString stringWithFormat:@"exports.write(\"%@\")", dataString];
    [self.webView evaluateJavaScript:jsToEvaluate completionHandler:^(id result, NSError *error) {
        lock(&self->_dataLock);
        self->_outputInProgress = NO;
        unlock(&self->_dataLock);
        if (error != nil) {
            NSLog(@"error sending bytes to the terminal: %@", error);
            return;
        }
    }];
}

//+ (void)convertCommand:(NSArray<NSString *> *)command toArgs:(char *)argv limitSize:(size_t)maxSize {
//    char *p = argv;
//    for (NSString *cmd in command) {
//        const char *c = cmd.UTF8String;
//        // Save space for the final NUL byte in argv
//        while (p < argv + maxSize - 1 && (*p++ = *c++));
//        // If we reach the end of the buffer, the last string still needs to be
//        // NUL terminated
//        *p = '\0';
//    }
//    // Add the final NUL byte to argv
//    *++p = '\0';
//}

+ (Terminal *)terminalWithType:(int)type number:(int)number {
    return [[Terminal alloc] initWithType:type number:number];
}

+ (Terminal *)terminalWithUUID:(NSUUID *)uuid {
    @synchronized (Terminal.class) {
        return [terminalsByUUID objectForKey:uuid];
    }
}

- (void)destroy {
    tty_t tty = self.tty;
    if (tty != NULL) {
        if (tty != NULL) {
            lock(&tty->lock);
            tty_hangup(tty);
            unlock(&tty->lock);
        }
    }
    @synchronized (Terminal.class) {
        [terminals removeObjectForKey:self.terminalsKey];
    }
}

+ (void)initialize {
    if (self == Terminal.class) {
        terminals = [NSMapTable strongToWeakObjectsMapTable];
        terminalsByUUID = [NSMapTable strongToWeakObjectsMapTable];
    }
}

@end

static int ios_tty_init(struct tty *tty) {
    // This is called with ttys_lock but that results in deadlock since the main thread can also acquire ttys_lock. So release it.
    unlock(&ttys_lock);
    void (^init_block)(void) = ^{
        Terminal *terminal = [Terminal terminalWithType:tty->type number:tty->num];
        tty->data = (void *) CFBridgingRetain(terminal);
        terminal.tty = tty;
    };
    if ([NSThread isMainThread])
        init_block();
    else
        dispatch_sync(dispatch_get_main_queue(), init_block);
    
    lock(&ttys_lock);
    return 0;
}

static int ios_tty_write(struct tty *tty, const void *buf, size_t len, bool blocking) {
    Terminal *terminal = (__bridge Terminal *) tty->data;
    return [terminal sendOutput:buf length:(int) len];
}

static void ios_tty_cleanup(struct tty *tty) {
    Terminal *terminal = CFBridgingRelease(tty->data);
    tty->data = NULL;
    terminal.tty = NULL;
}

struct tty_driver_ops ios_tty_ops = {
    .init = ios_tty_init,
    .write = ios_tty_write,
    .cleanup = ios_tty_cleanup,
};

static struct tty *ios_console_driver_ttys[64];
struct tty_driver ios_console_driver = {.ops = &ios_tty_ops, .major = TTY_CONSOLE_MAJOR, .ttys = ios_console_driver_ttys, .limit = 64};

struct tty_driver ios_pty_driver = {.ops = &ios_tty_ops};
