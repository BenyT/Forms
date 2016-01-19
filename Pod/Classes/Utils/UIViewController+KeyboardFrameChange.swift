//
//  UIViewController+KeyboardFrameChange.swift
//  PlaygroundProject
//
//  Created by mrandall on 10/27/15.
//  Copyright © 2015 mrandall. All rights reserved.
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
