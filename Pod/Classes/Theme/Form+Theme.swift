//
//  Form+Theme.swift
//  Forms
//
//  The MIT License (MIT)
//
//  Created by mrandall on 12/02/15.
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

