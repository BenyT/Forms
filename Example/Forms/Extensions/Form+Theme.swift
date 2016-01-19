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
    
    func themeViewFocused() {
        textField.layer.borderColor = UIColor.blueColor().CGColor
    }
}

extension FormSelectDateInputView {
    
    func themeViewFocused() {
        textField.layer.borderColor = UIColor.blueColor().CGColor
    }
}

extension FormSelectInputView {
    

    func themeViewFocused() {
        textField.layer.borderColor = UIColor.blueColor().CGColor
    }
}

