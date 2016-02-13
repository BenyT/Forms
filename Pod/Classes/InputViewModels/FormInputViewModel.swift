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

//MARK: - FormInputViewModelObservable

public protocol FormInputViewModelObservable {
    
    var identifier: String { get }
    
    var focused: Bool { get set }
    
    //attempts to make the view backed by this FormInputViewModelProtocol the firstResponder when the return key is tapped
    //does not affect the value of the returnKey; must be set to next manually
    var nextInputsViewModel: FormInputViewModelObservable? { get set }
    
    var focusedObservable: Observable<Bool> { get }
    var hiddenObservable: Observable<Bool> { get }
    var enabledObservable: Observable<Bool> { get }
    
    var displayValueObservable: Observable<String> { get }
    var captionObservable: Observable<NSAttributedString> { get }
    var placeholderObservable: Observable<NSAttributedString> { get }
    
    var returnKeyTypeObservable: Observable<UIReturnKeyType> { get }
    var secureTextEntryObservable: Observable<Bool> { get }
    var keyboardTypeObservable: Observable<UIKeyboardType> { get }
    var autocorrectionTypeObservable: Observable<UITextAutocorrectionType> { get }
    var autocaptializationTypeObservable: Observable<UITextAutocapitalizationType> { get }
    
    var validObservable: Observable<Bool> { get }
    var errorTextObservable: Observable<NSAttributedString?> { get }
    
    var inputViewLayoutObservable: Observable<InputViewLayout> { get }
}

//MARK: - InputViewLayout

final public class InputViewLayout: FormBaseTextInputViewLayout {
    
    public var insets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    public var inputLayoutAxis = UILayoutConstraintAxis.Vertical
    public var subviewSpacing = 0.0
    public var subviewOrder = [InputSubviews.TextField, InputSubviews.ErrorLabel, InputSubviews.CaptionLabel]
    
    init() { }
}

//Base class for FormInputViewModel
public class FormInputViewModel<T>: FormInputViewModelObservable, Equatable {
    
    //textfield text
    private let valueSubject = Subject<T?>()
    public var valueObservable: Observable<T?> { return valueSubject.asObservable() }
    public var value: T? {
        set {
            
            //only update observable if value is not nil
            if let value = newValue {
                valueSubject.next(value)
                valid = validateUsingDisplayValidationErrorsOnValueChangeValue()
                
                if let displayValueMap = displayValueMap {
                    displayValue = displayValueMap(value)
                } else {
                    displayValue = value as? String ?? "ERROR"
                }
                
            } else {
                valid = validateUsingDisplayValidationErrorsOnValueChangeValue()
                displayValue = ""
            }
        }
        get { return valueSubject.next ?? nil }
    }
    
    //map value to displya view
    public var displayValueMap: ((T) -> String)? {
        didSet {
            //set value to mapped display value through value didSet observer
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
    
    //focused
    private let focusedSubject = Subject<Bool>(false)
    public var focusedObservable: Observable<Bool> { return focusedSubject.asObservable() }
    public var focused: Bool {
        get { return focusedSubject.next! }
        set { focusedSubject.next(newValue) }
    }
    
    //hidden
    private let hiddenSubject = Subject<Bool>(false)
    public var hiddenObservable: Observable<Bool> { return hiddenSubject.asObservable() }
    public var hidden: Bool {
        get { return hiddenSubject.next! }
        set { hiddenSubject.next(newValue) }
    }
    
    //is viewModel view enabled
    //view is responsible for determining what this means
    private let enabledSubject = Subject<Bool>(true)
    public var enabledObservable: Observable<Bool> { return enabledSubject.asObservable() }
    public var enabled: Bool {
        get { return enabledSubject.next! }
        set { enabledSubject.next(newValue) }
    }
    
    //textfield text
    private let displayValueSubject = Subject<String>("")
    public var displayValueObservable: Observable<String> { return displayValueSubject.asObservable() }
    public var displayValue: String {
        get { return displayValueSubject.next! }
        set { displayValueSubject.next(newValue) }
    }
    
    //caption label text
    private let captionSubject = Subject<NSAttributedString>(NSAttributedString(string: ""))
    public var captionObservable: Observable<NSAttributedString> { return captionSubject.asObservable() }
    public var captionAttributedText: NSAttributedString? {
        get { return captionSubject.next! }
        set { captionSubject.next(newValue) }
    }
    public var caption: String {
        get { return captionSubject.next!.string }
        set { captionSubject.next(NSAttributedString(string: newValue)) }
    }
    
    //textfield placeholder
    private let placeholderSubject = Subject<NSAttributedString>(NSAttributedString(string: ""))
    public var placeholderObservable: Observable<NSAttributedString> { return placeholderSubject.asObservable() }
    public var placeholderAttributedText: NSAttributedString? {
        get { return placeholderSubject.next }
        set { placeholderSubject.next(newValue) }
    }
    public var placeholder: String {
        get { return placeholderSubject.next!.string }
        set { placeholderSubject.next(NSAttributedString(string: newValue)) }
    }
    
    //textfield return key
    private let returnKeySubject = Subject<UIReturnKeyType>(.Default )
    public var returnKeyTypeObservable: Observable<UIReturnKeyType> { return returnKeySubject.asObservable() }
    public var returnKeyType: UIReturnKeyType {
        get { return returnKeySubject.next! }
        set { returnKeySubject.next(newValue) }
    }
    
    //secure input
    private let secureTextEntrySubject = Subject<Bool>(false)
    public var secureTextEntryObservable: Observable<Bool> { return secureTextEntrySubject.asObservable() }
    public var secureTextEntry: Bool {
        get { return secureTextEntrySubject.next! }
        set { secureTextEntrySubject.next(newValue) }
    }
    
    //keyboardType
    private let keyboardTypeSubject = Subject<UIKeyboardType>(.Default)
    public var keyboardTypeObservable: Observable<UIKeyboardType> { return keyboardTypeSubject.asObservable() }
    public var keyboardType: UIKeyboardType {
        get { return keyboardTypeSubject.next! }
        set { keyboardTypeSubject.next(newValue) }
    }
    
    //autocorrectionType
    private let autocorrectionTypeSubject = Subject<UITextAutocorrectionType>(.Default)
    public var autocorrectionTypeObservable: Observable<UITextAutocorrectionType> { return autocorrectionTypeSubject.asObservable() }
    public var autocorrectionType: UITextAutocorrectionType {
        get { return autocorrectionTypeSubject.next! }
        set { autocorrectionTypeSubject.next(newValue) }
    }
    
    //autocaptializationType
    private let autocaptializationTypeSubject = Subject<UITextAutocapitalizationType>(.Sentences)
    public var autocaptializationTypeObservable: Observable<UITextAutocapitalizationType> { return autocaptializationTypeSubject.asObservable() }
    public var autocaptializationType: UITextAutocapitalizationType {
        get { return autocaptializationTypeSubject.next! }
        set { autocaptializationTypeSubject.next(newValue) }
    }
    
    //MARK: - FormInputValidatable Variables
    
    //whether input is valid
    private let validSubject = Subject<Bool>(true)
    public var validObservable: Observable<Bool> { return validSubject.asObservable() }
    public var valid: Bool {
        get { return validSubject.next! }
        set { validSubject.next(newValue) }
    }
    
    //error text if not value
    private let errorTextSubject = Subject<NSAttributedString?>()
    public var errorTextObservable: Observable<NSAttributedString?> { return errorTextSubject.asObservable() }
    public var errorAttributedText: NSAttributedString? {
        get {
            guard let value = errorTextSubject.next else { return nil }
            return value
        }
        set {
            if let value = newValue {
                errorTextSubject.next(value)
            }
        }
    }
    public var errorText: String? {
        get {
            guard let value = errorTextSubject.next else { return nil }
            return value!.string
        }
        set {
            if let value = newValue {
                errorTextSubject.next(NSAttributedString(string: value))
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
    
    //MARK: - Layout
    
    //layout of input
    private let inputViewLayoutSubject = Subject<InputViewLayout>(InputViewLayout())
    public var inputViewLayoutObservable: Observable<InputViewLayout> { return inputViewLayoutSubject.asObservable() }
    public var inputViewLayout: InputViewLayout {
        get { return inputViewLayoutSubject.next! }
        set { inputViewLayoutSubject.next(newValue) }
    }
    
    //MARK: - Init
    
    // Init
    //
    // - Parameter value: T
    public init(identifier: String, value: T? = nil, inputViewLayout: InputViewLayout = InputViewLayout()) {
        self.identifier = identifier
        valueSubject.next(value)
        displayValueSubject.next(self.value as? String ?? "")
        inputViewLayoutSubject.next(inputViewLayout)
    }
    
    public func validateUsingDisplayValidationErrorsOnValueChangeValue() -> Bool {
        return validate(updateErrorText: displayValidationErrorsOnValueChange)
    }
}

//MARK: - Equatable

public func ==<T>(lhs: FormInputViewModel<T>, rhs: FormInputViewModel<T>) -> Bool {
    return lhs.identifier == rhs.identifier
}

//MARK: - FormInputValidatable

extension FormInputViewModel: FormInputValidatable {
    
    public func validate() -> Bool {
        return validate(updateErrorText: true)
    }
}