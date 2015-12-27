//
//  FormInputViewModel.swift
//
//  Created by mrandall on 10/27/15.
//  Copyright © 2015 mrandall. All rights reserved.
//

import UIKit
import Bond

public protocol FormInputViewModelProtocol {
    
    //TODO: revisite with more time. Approach feels unbalanced
    //focused if set to true didSet observable (via focusedObservable) will attempt to make self.textfield the firstResponder
    //setting to false does not make the self.textfield attempt to resign first responder. Call resignFirstResponder directly on view
    var focused: Bool { get set }
    
    //attempts to make the view backed by this FormInputViewModelProtocol the firstResponder when the return key is tapped
    //does not affect the value of the returnKey; must be set to next manually
    var nextInputsViewModel: FormInputViewModelProtocol? { get set }
}

final public class InputViewLayout: FormBaseTextInputViewLayout {
    
    public var inputLayoutAxis = UILayoutConstraintAxis.Vertical
    
    public var subviewSpacing = 0.0
    
    public var subviewOrder = [InputSubviews.TextField, InputSubviews.ErrorLabel, InputSubviews.CaptionLabel]
    
    init() { }
}

//Base class for FormInputViewModel
public class FormInputViewModel<T>: FormInputViewModelProtocol, FormInputValidatable {
    
    //MARK: - FormInputViewModelProtocol
    
    //next input in form
    public var nextInputsViewModel: FormInputViewModelProtocol? {
        didSet {
            if nextInputsViewModel != nil {
                returnKeyType = .Next
            }
        }
    }
    
    //is viewModels view first responder
    public var focusedObservable =  Observable<Bool>(false)
    
    public var focused = false {
        didSet {
            if focused != oldValue {
                focusedObservable.next(focused)
            }
        }
    }
    
    //MARK: - State
    
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
    
    //textfield text
    public var displayValueObservable = Observable<String>("")
    
    public var displayValue: String = "" {
        didSet {
            if displayValue != oldValue {
                displayValueObservable.next(displayValue)
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
    
    //MARK: - State For Keyboard (No inputView)
    
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
    
    //MARK: - FormInputValidatable
    
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
    
    //layout of input
    public var inputViewLayoutObservable = Observable<InputViewLayout>(InputViewLayout())
    public var inputViewLayout: InputViewLayout
    
    //MARK: - Init
    
    // Init
    //
    // - Parameter value: T
    public init(value: T?, inputViewLayout: InputViewLayout = InputViewLayout()) {
    
        self.value = value
        valueObservable = Observable<T?>(value)
        
        displayValue = self.value as? String ?? ""
        displayValueObservable.next(displayValue)
        
        self.inputViewLayout = inputViewLayout
        inputViewLayoutObservable = Observable(self.inputViewLayout)
    }
    
    //MARK: - Validation
    
    public func validate() -> Bool {
        return validate(updateErrorText: true)
    }
    
    public func validateUsingDisplayValidationErrorsOnValueChangeValue() -> Bool {
        return validate(updateErrorText: displayValidationErrorsOnValueChange)
    }
}