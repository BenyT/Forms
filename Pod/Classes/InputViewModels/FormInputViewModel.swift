//
//  FormInputViewModel.swift
//
//  Created by mrandall on 10/27/15.
//  Copyright © 2015 mrandall. All rights reserved.
//

import UIKit
import Bond

public protocol FormInputViewModelProtocol {
    
    var nextInputsViewModel: FormInputViewModelProtocol? { get set }
    
    var isFirstResponder: Bool { get set }
}

//Base class for FormInputViewModel
public class FormInputViewModel<T>: FormInputViewModelProtocol, FormInputValidatable {
    
    //MARK: - FormInputViewModelProtocol
    
    public var nextInputsViewModel: FormInputViewModelProtocol? {
        didSet {
            if nextInputsViewModel != nil {
                returnKeyType = .Next
            }
        }
    }
    
    public var isFirstResponderObservable =  Observable<Bool>(false)
    
    public var isFirstResponder = false {
        didSet {
            if isFirstResponder != oldValue {
                isFirstResponderObservable.next(isFirstResponder)
            }
        }
    }
    
    //MARK: - State
    
    //textfield text
    public var valueObservable: Observable<T>
    
    public var value: T? {
        didSet {
            
            //only update observable if value is not nil
            if let value = value {
                valueObservable.next(value)
                
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
    public lazy var displayValueObservable = {
        return Observable<String>("")
    }()
    
    public var displayValue: String = "" {
        didSet {
            if displayValue != oldValue {
                displayValueObservable.next(displayValue)
            }
        }
    }
    
    public var displayValueMap: ((T) -> String)?
    
    //caption label text
    public var captionObservable = {
        return Observable<String>("")
    }()

    public var caption: String = "" {
        didSet {
            if caption != oldValue {
                captionObservable.next(caption)
            }
        }
    }
    
    //textfield placeholder
    public lazy var placeholderObservable = {
        return Observable<NSAttributedString>(NSAttributedString(string: ""))
    }()
    
    public var placeholder: String = "" {
        didSet {
            if placeholder != oldValue {
                placeholderObservable.next(NSAttributedString(string: placeholder))
            }
        }
    }
    
    //textfield return key
    public lazy var returnKeyTypeObservable = {
       return Observable<UIReturnKeyType>(.Default )
    }()
    
    public var returnKeyType: UIReturnKeyType = .Default {
        didSet {
            if returnKeyType != oldValue {
                returnKeyTypeObservable.next(returnKeyType)

            }
        }
    }
    
    //MARK: - State For Keyboard (No inputView)
    
    //secure input
    public lazy var secureTextEntryObservable = {
        return Observable<Bool>(false)
    }()
    
    public var secureTextEntry: Bool = false {
        didSet {
            if secureTextEntry != oldValue {
                secureTextEntryObservable.next(secureTextEntry)
                
            }
        }
    }
    
    //keyboardType
    public lazy var keyboardTypeObservable = {
        return Observable<UIKeyboardType>(.Default)
    }()
    
    public var keyboardType: UIKeyboardType = .Default {
        didSet {
            if keyboardType != oldValue {
                keyboardTypeObservable.next(keyboardType)
            }
        }
    }
    
    //autocorrectionType
    public lazy var autocorrectionTypeObservable = {
        return Observable<UITextAutocorrectionType>(.Default)
    }()
    
    public var autocorrectionType: UITextAutocorrectionType = .Default {
        didSet {
            if autocorrectionType != oldValue {
                autocorrectionTypeObservable.next(autocorrectionType)
            }
        }
    }
    
    //MARK: - FormInputValidatable
    
    //whether input is valid
    public lazy var validObservable = {
        return Observable<Bool>(false)
    }()
    
    public var valid = false {
        didSet {
            if valid != oldValue {
                validObservable.next(valid)
            }
        }
    }
    
    //error text if not value
    public lazy var errorTextObservable = {
        return Observable<String>("")
    }()
    
    public var errorText: String? {
        didSet {
            if errorText != oldValue {
                errorTextObservable.next(errorText ?? "")
            }
        }
    }
    
    public var validationRules = [FormInputValidationRule<T>]()
    
    public var inputValueToValidate: T? { return self.value }
    
    //MARK: - Init
    
    // Init
    //
    // - Parameter value: T
    public init(value: T, caption: String = "") {
        self.value = value
        valueObservable = Observable<T>(value)
        self.displayValue = self.value as? String ?? ""
        self.caption = caption
        captionObservable.next(caption)
    }
}