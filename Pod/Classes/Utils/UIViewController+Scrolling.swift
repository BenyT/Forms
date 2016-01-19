//
//  UIViewController+Scrolling.swift
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

public extension UIViewController {
    
    /// Embed view in scrollView
    ///
    /// - Parameter view: UIView which contains scrollView content
    /// - Returns UIScrollView which was created
    public func embedViewInScrollView(scrollViewContainerView: UIView) -> UIScrollView {
        
        //create scrollview
        let scrollView = UIScrollView()
        
        //move scrollViewContentView from self.view into scrollView
        scrollViewContainerView.removeFromSuperview()
        scrollView.addSubview(scrollViewContainerView)
        view.insertSubview(scrollView, atIndex: 0)
        
        //pin scrollViewContentView to scrollview edges
        UIView.createConstraints(
            visualFormatting: ["H:|[v]|", "V:|[v]|"],
            views: ["v": scrollViewContainerView]
        )
        
        //pin scrollView to self.view edges
        UIView.createConstraints(
            visualFormatting: ["H:|[v]|", "V:|[v]|"],
            views: ["v": scrollView]
        )
        
        //set scrollViewContentView width to match self.view width
        let constraint = NSLayoutConstraint(
            item: scrollViewContainerView,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0.0
        )
        constraint.active = true
        
        return scrollView
    }
}