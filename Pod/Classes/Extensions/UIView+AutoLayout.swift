//
//  UIView+AutoLayout.swift
//
//  Created by mrandall on 10/14/15.
//  Copyright © 2015 mrandall. All rights reserved.
//
import UIKit

extension UIView {
    
    /// Creates constraints from visualFormatting strings
    /// An NSLayoutConstraint is created from each visualFormatting element and activated
    /// views values have translatesAutoresizingMaskIntoConstraints set to false
    ///
    /// - Parameter visualFormatting: [String]
    /// - Parameter views: [String: UIView]
    /// - Returns [NSLayoutConstraint]
    func createConstraints(visualFormatting visualFormatting: [String], views: [String: UIView]) -> [NSLayoutConstraint] {
        
        for view in views.values {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        var constraints = [NSLayoutConstraint]()
        for visualFormat in visualFormatting {
            constraints += NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: [], metrics: nil, views: views)
        }
        
        constraints.forEach({ $0.active = true })
        
        return constraints
    }
}