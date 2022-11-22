//
//  MySwift.swift
//  iSH
//
//  Created by pcl on 10/26/22.
//

import Foundation

@objc class MySwift: NSObject {
    
}

@objc class MyHandler: NSObject, WKScriptMessageHandler {
    
    var handler: WKScriptMessageHandler?
    
    @objc init(x: WKScriptMessageHandler?) {
        super.init()
        self.handler = x
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.handler?.userContentController(userContentController, didReceive: message)
    }
    
}

//@objc class MyTV: UIView, UITextInput, WKScriptMessageHandler, UIScrollViewDelegate {
//    
//    override var canBecomeFirstResponder:Bool!{
//        return true
//    }
//    var isControlSelected:Bool!
//    var isControlHighlighted:Bool!
//    override var inputAccessoryView:UIView!{
//        return UIView()
//    }
//    
//    func text(in range: UITextRange) -> String? {
//        <#code#>
//    }
//    
//    func replace(_ range: UITextRange, withText text: String) {
//        <#code#>
//    }
//    
//    var selectedTextRange: UITextRange?
//    
//    var markedTextRange: UITextRange?
//    
//    var markedTextStyle: [NSAttributedString.Key : Any]?
//    
//    func setMarkedText(_ markedText: String?, selectedRange: NSRange) {
//        <#code#>
//    }
//    
//    func unmarkText() {
//        <#code#>
//    }
//    
//    var beginningOfDocument: UITextPosition
//    
//    var endOfDocument: UITextPosition
//    
//    func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? {
//        <#code#>
//    }
//    
//    func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
//        <#code#>
//    }
//    
//    func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? {
//        <#code#>
//    }
//    
//    func compare(_ position: UITextPosition, to other: UITextPosition) -> ComparisonResult {
//        <#code#>
//    }
//    
//    func offset(from: UITextPosition, to toPosition: UITextPosition) -> Int {
//        <#code#>
//    }
//    
//    var inputDelegate: UITextInputDelegate?
//    
//    var tokenizer: UITextInputTokenizer
//    
//    func position(within range: UITextRange, farthestIn direction: UITextLayoutDirection) -> UITextPosition? {
//        <#code#>
//    }
//    
//    func characterRange(byExtending position: UITextPosition, in direction: UITextLayoutDirection) -> UITextRange? {
//        <#code#>
//    }
//    
//    func baseWritingDirection(for position: UITextPosition, in direction: UITextStorageDirection) -> NSWritingDirection {
//        <#code#>
//    }
//    
//    func setBaseWritingDirection(_ writingDirection: NSWritingDirection, for range: UITextRange) {
//        <#code#>
//    }
//    
//    func firstRect(for range: UITextRange) -> CGRect {
//        <#code#>
//    }
//    
//    func caretRect(for position: UITextPosition) -> CGRect {
//        <#code#>
//    }
//    
//    func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
//        <#code#>
//    }
//    
//    func closestPosition(to point: CGPoint) -> UITextPosition? {
//        <#code#>
//    }
//    
//    func closestPosition(to point: CGPoint, within range: UITextRange) -> UITextPosition? {
//        <#code#>
//    }
//    
//    func characterRange(at point: CGPoint) -> UITextRange? {
//        <#code#>
//    }
//    
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        <#code#>
//    }
//    
//    var hasText: Bool
//    
//    func insertText(_ text: String) {
//        <#code#>
//    }
//    
//    func deleteBackward() {
//        <#code#>
//    }
//    
//}
