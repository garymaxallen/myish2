#import <UIKit/UIKit.h>
#import "Terminal.h"

//enum OverrideAppearance {
//    OverrideAppearanceNone,
//    OverrideAppearanceLight,
//    OverrideAppearanceDark,
//};

@interface TerminalView : UIView <UITextInput, WKScriptMessageHandler, UIScrollViewDelegate>

//@property IBInspectable (nonatomic) BOOL canBecomeFirstResponder;
@property (nonatomic) BOOL canBecomeFirstResponder;

//@property (nonatomic) CGFloat overrideFontSize;
//@property (readonly) CGFloat effectiveFontSize;
//@property (nonatomic) enum OverrideAppearance overrideAppearance;

//@property (nonatomic) UIKeyboardAppearance keyboardAppearance;

@property UIView *inputAccessoryView;
@property BOOL isControlSelected;
@property BOOL isControlHighlighted;

@property (nonatomic) Terminal *terminal;

@end
