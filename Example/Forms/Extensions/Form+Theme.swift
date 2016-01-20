//
//  Form+Theme.swift
//  Forms
//
//  Created by mrandall on 12/5/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import Forms

extension UITextField {
    
    func themeForFormInput() {
        layer.borderColor = UIColor.lightGrayColor().CGColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
        leftView = UIView(frame: CGRectMake(0, 0, 10.0, frame.size.height))
        leftViewMode = .Always
        heightAnchor.constraintEqualToConstant(44.0).active = true
        clearButtonMode = .WhileEditing
    }
}

extension UILabel {
    
    func themeForFormInputError() {
        textColor = UIColor.redColor()
        font = UIFont.boldSystemFontOfSize(font.pointSize)
    }
    
    func themeForFormInputCaption() {
        textColor = UIColor.grayColor()
    }
}

extension FormInputView where Self: KeyboardFormIputView {
    
    func themeView() {
        textField.themeForFormInput()
        errorLabel.themeForFormInputError()
        captionLabel.themeForFormInputCaption()
    }
    
    func themeViewFocused() {
        textField.layer.borderColor = UIColor.blueColor().CGColor
    }
}

extension FormInputView where Self: ButtonFormIputView {
    
    func themeView() {
        button.setImage(UIImage(named: "control_checkbox_checked"), forState: .Selected)
        button.layer.borderColor = UIColor.lightGrayColor().CGColor
        button.layer.borderWidth = 1.0
        button.heightAnchor.constraintEqualToConstant(44.0).active = true
        errorLabel.themeForFormInputError()
        captionLabel.themeForFormInputCaption()
    }
}


