//
//  FormInputViewModel.swift
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
import Bond

public protocol FormInputViewModelObservable {
    
    var identifier: String { get }
    
    var focused: Bool { get set }
    
    //attempts to make the view backed by this FormInputViewModelProtocol the firstResponder when the return key is tapped
    //does not affect the value of the returnKey; must be set to next manually
    var nextInputsViewModel: FormInputViewModelObservable? { get set }
    
    //TODO: revisite with more time. Approach feels unbalanced
    //focused if set to true didSet observable (via focusedObservable) will attempt to make self.textfield the firstResponder
    //setting to false does not make the self.textfield attempt to resign first responder. Call resignFirstResponder directly on view
    //is viewModels view first responder
    var focusedObservable: Observable<Bool> { get }
    
    var enabledObservable: Observable<Bool> { get }
    
    var displayValueObservable: Observable<String> { get }
    
    var captionObservable: Observable<NSAttributedString> { get }
    
    var placeholderObservable: Observable<NSAttributedString> { get }
    
    var returnKeyTypeObservable: Observable<UIReturnKeyType> { get }
    
    var secureTextEntryObservable: Observable<Bool> { get }
    
    var keyboardTypeObservable: Observable<UIKeyboardType> { get }
    
    var autocorrectionTypeObservable: Observable<UITextAutocorrectionType> { get }

    var validObservable: Observable<Bool> { get }
    
    var errorTextObservable: Observable<NSAttributedString> { get }
    
    var inputViewLayoutObservable: Observable<InputViewLayout> { get }
}

final public class InputViewLayout: FormBaseTextInputViewLayout {
    
    public var insets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    public var inputLayoutAxis = UILayoutConstraintAxis.Vertical
    
    public var subviewSpacing = 0.0
    
    public var subviewOrder = [InputSubviews.TextField, InputSubviews.ErrorLabel, InputSubviews.CaptionLabel]
    
    init() { }
}

//TODO: non observer values are not updated if observers are updated directy

//Base class for FormInputViewModel
public class FormInputViewModel<T>: FormInputViewModelObservable {
    
    //textfield text
    public var valueObservable: Observable<T?>
    public var value: T? {
        didSet {
            
            //only update observable if value is not nil
            if let value = value {
                valueObservable.next(value)
                
                valid = validateUsingDisplayValidationErrorsOnValueChangeValue()
                
                if let displayValueMap = displayValueMap {
                    displayValue = displayValueMap(value)
                } else {
                    displayValue = value as? String ?? "ERROR"
                }
                
            } else {
                displayValue = ""
            }
        }
    }
    
    //map value to displya view
    public var displayValueMap: ((T) -> String)? {
        didSet {
            
            //set value to map display to value through value didSet observer
            let value = self.value
            self.value = value
        }
    }
    
    //MARK: - FormInputViewModelProtocol
    
    public var identifier: String
    
    public var nextInputsViewModel: FormInputViewModelObservable? {
        didSet {
            if nextInputsViewModel != nil {
                returnKeyType = .Next
            }
        }
    }
    
    public var focusedObservable = Observable<Bool>(false)
    public var focused = false {
        didSet {
            if focused != oldValue {
                focusedObservable.next(focused)
            }
        }
    }
    
    //is viewModel view enabled
    //view is responsible for determining what this means
    public var enabledObservable = Observable<Bool>(true)
    public var enabled: Bool = true {
        didSet {
            if enabled != oldValue {
                enabledObservable.next(enabled)
            }
        }
    }
    
    //textfield text
    public var displayValueObservable = Observable<String>("")
    public var displayValue: String = "" {
        didSet {
            if displayValue != oldValue {
                displayValueObservable.next(displayValue)
            }
        }
    }
    
    //caption label text
    public var captionObservable = Observable<NSAttributedString>(NSAttributedString(string: ""))
    public var caption: String = "" {
        didSet {
            if caption != oldValue {
                captionObservable.next(NSAttributedString(string: caption))
            }
        }
    }
    public var captionAttributedText: NSAttributedString? {
        didSet {
            if captionAttributedText?.string != caption {
                captionObservable.next(captionAttributedText!)
            }
        }
    }
    
    //textfield placeholder
    public var placeholderObservable = Observable<NSAttributedString>(NSAttributedString(string: ""))
    public var placeholder: String = "" {
        didSet {
            if placeholder != oldValue {
                placeholderObservable.next(NSAttributedString(string: placeholder))
            }
        }
    }
    public var placeholderAttributedText: NSAttributedString? {
        didSet {
            if placeholderAttributedText?.string != placeholder {
                placeholderObservable.next(placeholderAttributedText!)
            }
        }
    }
    
    //textfield return key
    public var returnKeyTypeObservable = Observable<UIReturnKeyType>(.Default )
    public var returnKeyType: UIReturnKeyType = .Default {
        didSet {
            if returnKeyType != oldValue {
                returnKeyTypeObservable.next(returnKeyType)
            }
        }
    }
    
    //secure input
    public var secureTextEntryObservable = Observable<Bool>(false)
    public var secureTextEntry: Bool = false {
        didSet {
            if secureTextEntry != oldValue {
                secureTextEntryObservable.next(secureTextEntry)
            }
        }
    }
    
    //keyboardType
    public var keyboardTypeObservable = Observable<UIKeyboardType>(.Default)
    public var keyboardType: UIKeyboardType = .Default {
        didSet {
            if keyboardType != oldValue {
                keyboardTypeObservable.next(keyboardType)
            }
        }
    }
    
    //autocorrectionType
    public var autocorrectionTypeObservable = Observable<UITextAutocorrectionType>(.Default)
    public var autocorrectionType: UITextAutocorrectionType = .Default {
        didSet {
            if autocorrectionType != oldValue {
                autocorrectionTypeObservable.next(autocorrectionType)
            }
        }
    }
    
    //layout of input
    public var inputViewLayoutObservable = Observable<InputViewLayout>(InputViewLayout())
    public var inputViewLayout: InputViewLayout {
        didSet {
            inputViewLayoutObservable.next(inputViewLayout)
        }
    }
    
    //MARK: - FormInputValidatable Variables
    
    //whether input is valid
    public var validObservable = Observable<Bool>(true)
    public var valid = true {
        didSet {
            if valid != oldValue {
                validObservable.next(valid)
            }
        }
    }
    
    //error text if not value
    public var errorTextObservable = Observable<NSAttributedString>(NSAttributedString(string: ""))
    public var errorText: String? {
        didSet {
            if errorText != oldValue {
                errorTextObservable.next(NSAttributedString(string: errorText ?? ""))
            }
        }
    }
     
    public var validationRules = [FormInputValidationRule<T>]() {
        didSet {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.validate(updateErrorText: self.displayValidationErrorsOnValueChange)
            }
        }
    }
    
    public var inputValueToValidate: T? { return self.value }
    public var displayValidationErrorsOnValueChange: Bool = false {
        didSet {
            if displayValidationErrorsOnValueChange == true {
                validateUsingDisplayValidationErrorsOnValueChangeValue()
            }
        }
    }
 
    //MARK: - Init
    
    // Init
    //
    // - Parameter value: T
    public init(identifier: String, value: T?, inputViewLayout: InputViewLayout = InputViewLayout()) {
    
        self.identifier = identifier
        self.value = value
        valueObservable = Observable<T?>(value)
        
        displayValue = self.value as? String ?? ""
        displayValueObservable.next(displayValue)
        
        self.inputViewLayout = inputViewLayout
        inputViewLayoutObservable = Observable(self.inputViewLayout)
    }
    
    public func validateUsingDisplayValidationErrorsOnValueChangeValue() -> Bool {
        return validate(updateErrorText: displayValidationErrorsOnValueChange)
    }
}

//MARK: - FormInputValidatable

extension FormInputViewModel: FormInputValidatable {
    
    public func validate() -> Bool {
        return validate(updateErrorText: true)
    }
}