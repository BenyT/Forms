//
//  Form+Theme.swift
//  Forms
//
//  Created by mrandall on 12/5/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit

extension FormTextInputView {
    
    func themeView() {
        textField.themeForFormInput()
        errorLabel.themeForFormInputError()
        captionLabel.themeForFormInputCaption()
    }
    
    func themeViewFocused() {
        textField.layer.borderColor = UIColor.blueColor().CGColor
    }
}

extension FormSelectDateInputView {
    
    func themeView() {
        textField.themeForFormInput()
        errorLabel.themeForFormInputError()
        captionLabel.themeForFormInputCaption()
    }
    
    func themeViewFocused() {
        textField.layer.borderColor = UIColor.blueColor().CGColor
    }
}

extension FormSelectInputView {
    
    func themeView() {
        textField.themeForFormInput()
        errorLabel.themeForFormInputError()
        captionLabel.themeForFormInputCaption()
    }
    
    func themeViewFocused() {
        textField.layer.borderColor = UIColor.blueColor().CGColor
    }
}

extension FormCheckboxInputView {
    
    func themeView() {
        checkBoxButton.setImage(UIImage(named: "control_checkbox_checked"), forState: .Selected)
        checkBoxButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        checkBoxButton.layer.borderWidth = 1.0
        checkBoxButton.heightAnchor.constraintEqualToConstant(44.0).active = true
        errorLabel.themeForFormInputError()
        captionLabel.themeForFormInputCaption()
    }
}

//MARK: - UIKit theming for FormInputView subviews

private extension UITextField {
    
    //Theme text input for all inputs which have a text input
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

private extension UILabel {
    
    func themeForFormInputError() {
        textColor = UIColor.redColor()
        font = UIFont.boldSystemFontOfSize(font.pointSize)
    }
    
    func themeForFormInputCaption() {
        textColor = UIColor.grayColor()
    }
}

