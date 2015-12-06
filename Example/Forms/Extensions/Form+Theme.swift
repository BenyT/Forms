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
    
    func themeView() {
        
        textField.layer.borderColor = UIColor.lightGrayColor().CGColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.leftView = UIView(frame: CGRectMake(0, 0, 10.0, frame.size.height))
        textField.leftViewMode = .Always
        textField.clearButtonMode = .WhileEditing
        
        errorLabel.textColor = UIColor.redColor()
        
        captionLabel.textColor = UIColor.grayColor()
    }
}

extension FormCheckboxInputView {
    
    func themeView() {
        
        checkBoxButton.setImage(UIImage(named: "control_checkbox_checked"), forState: .Selected)
        checkBoxButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        checkBoxButton.layer.borderWidth = 1.0
        
        errorLabel.textColor = UIColor.redColor()
        
        captionLabel.textColor = UIColor.grayColor()
    }
}

