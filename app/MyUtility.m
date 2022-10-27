//
//  MyUtility.m
//  iSH
//
//  Created by pcl on 10/10/22.
//

#import "MyUtility.h"

#include "kernel/init.h"
#include "fs/devices.h"
#include "fs/path.h"
#import "LocationDevice.h"
#include "fs/dyndev.h"
#import "Terminal.h"
#include "kernel/calls.h"
#include <resolv.h>
#include <netdb.h>

//#import "Roots.h"

#import "iSH-Swift.h"

@interface MyUtility()

@end

@implementation MyUtility

+ (struct fd *)get_at_pwd {
    return AT_PWD;
}

+ (NSURL *)get_root {
//    return [RootsDir2() URLByAppendingPathComponent:@"default"];
    static NSURL *rootsDir;
    rootsDir = [[NSFileManager.defaultManager containerURLForSecurityApplicationGroupIdentifier:@"group.app.ish.iSH"] URLByAppendingPathComponent:@"roots"];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtURL:rootsDir
      withIntermediateDirectories:YES
                       attributes:@{}
                            error:nil];
//    static dispatch_once_t token;
//    dispatch_once(&token, ^{
//        rootsDir = [[NSFileManager.defaultManager containerURLForSecurityApplicationGroupIdentifier:@"group.app.ish.iSH"] URLByAppendingPathComponent:@"roots"];
//        NSFileManager *manager = [NSFileManager defaultManager];
//        [manager createDirectoryAtURL:rootsDir
//          withIntermediateDirectories:YES
//                           attributes:@{}
//                                error:nil];
//    });
    return [rootsDir URLByAppendingPathComponent:@"default"];
}

+ (void)boot {
    //    [MySwift printSome];
    //    NSURL *rootsDir = [[NSFileManager.defaultManager containerURLForSecurityApplicationGroupIdentifier:@"group.app.ish.iSH"] URLByAppendingPathComponent:@"roots"];
    //    NSURL *root = [rootsDir URLByAppendingPathComponent:[NSUserDefaults.standardUserDefaults stringForKey:@"Default Root"]];
    
    //    NSURL *root = [Roots.instance rootUrl:Roots.instance.defaultRoot];
    //    NSLog(@"root: %@", root);
    
    //    int err = mount_root(&fakefs, [root URLByAppendingPathComponent:@"data"].fileSystemRepresentation);
    //    int err = mount_root(&fakefs, [self get_root]);
    
    
    //    NSLog(@"com.gg.mysh.log: root: %s", [self get_root]);
    //    mount_root(&fakefs, [[Roots.instance rootUrl:Roots.instance.defaultRoot]  URLByAppendingPathComponent:@"data"].fileSystemRepresentation);
    
//    mount_root(&fakefs, [MySwift get_root]);
//    mount_root([MySwift get_fakefs], [MySwift get_root]);
    
    // need to do this first so that we can have a valid current for the generic_mknod calls
    //    become_first_process();
//    [MySwift printSome];
    
    // create some device nodes
    // this will do nothing if they already exist
    //    NSLog(@"com.mycom.mytest2.log: root: %@", AT_PWD);
    //    generic_mknodat([self get_at_pwd], "/dev/tty1", S_IFCHR|0666, dev_make(TTY_CONSOLE_MAJOR, 1));
    
//    struct fd *ptr = (struct fd *)-2;
//    struct fd *ptr = (struct fd *)-100;
//    generic_mknodat([MySwift get_fd], "/dev/tty1", S_IFCHR|0666, dev_make(TTY_CONSOLE_MAJOR, 1));
//    generic_mknodat(ptr, "/dev/tty2", S_IFCHR|0666, dev_make(TTY_CONSOLE_MAJOR, 2));
//    generic_mknodat(ptr, "/dev/tty3", S_IFCHR|0666, dev_make(TTY_CONSOLE_MAJOR, 3));
//    generic_mknodat(ptr, "/dev/tty4", S_IFCHR|0666, dev_make(TTY_CONSOLE_MAJOR, 4));
//    generic_mknodat(ptr, "/dev/tty5", S_IFCHR|0666, dev_make(TTY_CONSOLE_MAJOR, 5));
//    generic_mknodat(ptr, "/dev/tty6", S_IFCHR|0666, dev_make(TTY_CONSOLE_MAJOR, 6));
//    generic_mknodat(ptr, "/dev/tty7", S_IFCHR|0666, dev_make(TTY_CONSOLE_MAJOR, 7));
//
//    generic_mknodat(ptr, "/dev/tty", S_IFCHR|0666, dev_make(TTY_ALTERNATE_MAJOR, DEV_TTY_MINOR));
//    generic_mknodat(ptr, "/dev/console", S_IFCHR|0666, dev_make(TTY_ALTERNATE_MAJOR, DEV_CONSOLE_MINOR));
//    generic_mknodat(ptr, "/dev/ptmx", S_IFCHR|0666, dev_make(TTY_ALTERNATE_MAJOR, DEV_PTMX_MINOR));
//
//    generic_mknodat(ptr, "/dev/null", S_IFCHR|0666, dev_make(MEM_MAJOR, DEV_NULL_MINOR));
//    generic_mknodat(ptr, "/dev/zero", S_IFCHR|0666, dev_make(MEM_MAJOR, DEV_ZERO_MINOR));
//    generic_mknodat(ptr, "/dev/full", S_IFCHR|0666, dev_make(MEM_MAJOR, DEV_FULL_MINOR));
//    generic_mknodat(ptr, "/dev/random", S_IFCHR|0666, dev_make(MEM_MAJOR, DEV_RANDOM_MINOR));
//    generic_mknodat(ptr, "/dev/urandom", S_IFCHR|0666, dev_make(MEM_MAJOR, DEV_URANDOM_MINOR));
//
//    generic_mkdirat(ptr, "/dev/pts", 0755);
//
//    // Permissions on / have been broken for a while, let's fix them
//    generic_setattrat(ptr, "/", (struct attr) {.type = attr_mode, .mode = 0755}, false);
    
//    dyn_dev_register(&location_dev, DEV_CHAR, DYN_DEV_MAJOR, DEV_LOCATION_MINOR);
//    
//    generic_mknodat(ptr, "/dev/location", S_IFCHR|0666, dev_make(DYN_DEV_MAJOR, DEV_LOCATION_MINOR));
    
//    [MySwift boot1];
    
//    do_mount(&procfs, "proc", "/proc", "", 0);
//    do_mount(&devptsfs, "devpts", "/dev/pts", "", 0);
    
//    [self configureDns];
    
//    [MySwift boot2];
//    [self configureDns];
    
//    tty_drivers[TTY_CONSOLE_MAJOR] = &ios_console_driver;
//
//    set_console_device(TTY_CONSOLE_MAJOR, 1);
//    create_stdio("/dev/console", TTY_CONSOLE_MAJOR, 1);
//
//    do_execve("/bin/login", 3, "/bin/login\0-f\0root\0", "TERM=xterm-256color\0");
//
//    task_start(current);
}

+ (void)configureDns {
    struct __res_state res;
    if (EXIT_SUCCESS != res_ninit(&res)) {
        exit(2);
    }
    NSMutableString *resolvConf = [NSMutableString new];
    if (res.dnsrch[0] != NULL) {
        [resolvConf appendString:@"search"];
        for (int i = 0; res.dnsrch[i] != NULL; i++) {
            [resolvConf appendFormat:@" %s", res.dnsrch[i]];
        }
        [resolvConf appendString:@"\n"];
    }
    union res_sockaddr_union servers[NI_MAXSERV];
    int serversFound = res_getservers(&res, servers, NI_MAXSERV);
    char address[NI_MAXHOST];
    for (int i = 0; i < serversFound; i ++) {
        union res_sockaddr_union s = servers[i];
        if (s.sin.sin_len == 0)
            continue;
        getnameinfo((struct sockaddr *) &s.sin, s.sin.sin_len,
                    address, sizeof(address),
                    NULL, 0, NI_NUMERICHOST);
        [resolvConf appendFormat:@"nameserver %s\n", address];
    }
    
    current = pid_get_task(1);
    struct fd *fd = generic_open("/etc/resolv.conf", O_WRONLY_ | O_CREAT_ | O_TRUNC_, 0666);
    if (!IS_ERR(fd)) {
        fd->ops->write(fd, resolvConf.UTF8String, [resolvConf lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
        fd_close(fd);
    }
}

- (void)getCaller{
    // must be placed in function directly
    NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];
    NSLog(@"Stack = %@", [array objectAtIndex:0]);
    NSLog(@"Framework = %@", [array objectAtIndex:1]);
    NSLog(@"Memory address = %@", [array objectAtIndex:2]);
    NSLog(@"Class caller = %@", [array objectAtIndex:3]);
    NSLog(@"Function caller = %@", [array objectAtIndex:4]);
}

@end
