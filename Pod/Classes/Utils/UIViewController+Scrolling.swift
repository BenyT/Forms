//
//  UIViewController+Scrolling.swift
//  PlaygroundProject
//
//  Created by mrandall on 10/27/15.
//  Copyright © 2015 mrandall. All rights reserved.
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