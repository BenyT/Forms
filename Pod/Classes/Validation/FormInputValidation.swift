//
//  FormInputValidation.swift
//
//  The MIT License (MIT)
//
//  Created by mrandall on 11/05/15.
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

import Foundation

//MARK: - FormInputValidatable

public enum FormInputValidatableProperty: String {
    case Valid
    case ErrorText
}

public protocol FormInputValidatable: class {
    
    typealias InputDataType
    
    //is input value valid
    var valid: Bool { get set }
    
    //value to validate
    var inputValueToValidate: InputDataType? { get }
    
    //error label text
    var errorText: String? { get set }
    
    //validation rules run by validate method
    var validationRules: [FormInputValidationRule<InputDataType>] { get }
    
    /// Validate input
    ///
    /// - Return: Bool whether any validationRules failed
    func validate(updateErrorText updateErrorText: Bool) -> Bool
}

public extension FormInputValidatable {
    
    //MARK: InputValidation
    
    /// Updates errorText specified by the first failed validation rule
    func validate(updateErrorText updateErrorText: Bool) -> Bool {
        
        //validate each rule
        let validationFailure = self.validationRules.filter {
            
            //assuming no validation rule will ever allow a nil value
            guard let value = self.inputValueToValidate else {
                return true
            }
            
            return !$0.validate(inputValue: value)
        }.first
        
        guard case .None = validationFailure else {
            
            if updateErrorText == true {
                self.errorText = validationFailure!.errorText
            }
            
            valid = false
            return false
        }
        
        //clear error
        if updateErrorText == true {
            self.errorText = nil
        }
        
        valid = true
        return true
    }
}

//MARK: - FormInputValidationRule

public class FormInputValidationRule<T> {
    
    public var errorText: String
    
    public var validationClosure: ((T) -> Bool)
    
    public init(failureText: String, validation: ((T) -> Bool)) {
        self.errorText = failureText
        self.validationClosure = validation
    }
    
    public func validate(inputValue inputValue: T) -> Bool {
        return validationClosure(inputValue)
    }
}