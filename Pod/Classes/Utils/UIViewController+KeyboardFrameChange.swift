//
//  UIViewController+KeyboardFrameChange.swift
//  Forms
//
//  The MIT License (MIT)
//
//  Created by mrandall on 10/27/15.
//  Copyright © 2015 mrandall. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

///Convenience for Keyboard frame change handling
public protocol AnimateWithKeyboardFrameWillChangeNotificationHandler {
    
    ///Adds UIKeyboardWillChangeFrameNotification observer
    func startObservingKeyboardFrameChange()
    
    ///Removes UIKeyboardWillChangeFrameNotification observer
    func stopObservingKeyboardFrameChange()
    
    /// Called in animation block which animates along side the keyboard frame change animation
    ///
    /// - Parameter keyboardEndFrame: CGRect that the keyboard is animated to
    func animatateOnKeyboardWillChange(keyboardEndFrame: CGRect)
}

public extension AnimateWithKeyboardFrameWillChangeNotificationHandler where Self: UIViewController {
    
    public func startObservingKeyboardFrameChange() {
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self] (notification) in
            self?.keyboardWillChangeFrameNotification(notification)
        }
    }
    
    public func stopObservingKeyboardFrameChange() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    private func keyboardWillChangeFrameNotification(notification: NSNotification) {
        
        guard
            let userInfo = notification.userInfo,
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
        else {
            return
        }
        
        //duration
        let duration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        
        //pseudo-match the built in curve
        let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
        let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
        
        //animate
        UIView.animateWithDuration(duration, delay: NSTimeInterval(0), options: animationCurve, animations: {
            self.animatateOnKeyboardWillChange(endFrame)
            self.view.setNeedsLayout()
            }, completion: nil)
    }
    
    public func animatateOnKeyboardWillChange(keyboardEndFrame: CGRect) { }
}
