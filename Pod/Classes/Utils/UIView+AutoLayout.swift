//
//  UIView+AutoLayout.swift
//  Forms
//
//  The MIT License (MIT)
//
//  Created by mrandall on 10/14/15.
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

public extension UIView {
    
    /// Creates constraints from visualFormatting strings
    /// An NSLayoutConstraint is created from each visualFormatting element and activated
    /// views values have translatesAutoresizingMaskIntoConstraints set to false
    ///
    /// - Parameter visualFormatting: [String]
    /// - Parameter views: [String: UIView]
    /// - Returns [NSLayoutConstraint]
    public static func createConstraints(visualFormatting visualFormatting: [String], views: [String: UIView]) -> [NSLayoutConstraint] {
        
        for view in views.values {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        var constraints = [NSLayoutConstraint]()
        for visualFormat in visualFormatting {
            constraints += NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: [], metrics: nil, views: views)
        }
        
        constraints.forEach { $0.active = true }
        
        return constraints
    }
}