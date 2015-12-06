//
//  Form+Theme.swift
//  Forms
//
//  Created by mrandall on 12/5/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import Forms

extension FormTextInputView {
    
    override public func themeView() {
        
        textField.layer.borderColor = UIColor.grayColor().CGColor
        textField.layer.borderWidth = 1.0
        
        //left padding
        textField.leftView = UIView(frame: CGRectMake(0, 0, 10.0, frame.size.height))
        textField.leftViewMode = .Always
        
        //clear button
        textField.clearButtonMode = .WhileEditing
    }
}
