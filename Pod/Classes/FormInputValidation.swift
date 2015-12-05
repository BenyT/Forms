//
//  FormInputValidation.swift
//
//  Created by mrandall on 11/5/15.
//  Copyright © 2015 mrandall. All rights reserved.
//

import Foundation

//MARK: - FormInputValidatable

enum FormInputValidatableProperty: String {
    case Valid
    case ErrorText
}

protocol FormInputValidatable: class {
    
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
    func validate() -> Bool
}

extension FormInputValidatable {
    
    //MARK: InputValidation
    
    /// Updates errorText specified by the first failed validation rule
    func validate() -> Bool {
        
        defer {
            valid = errorText == nil
        }
        
        //clear error
        self.errorText = nil
        
        //validate each rule
        let validationFailure = self.validationRules.filter {
            
            //assuming no validation rule will ever allow a nil value
            guard let value = self.inputValueToValidate else {
                return false
            }
            
            return !$0.validate(inputValue: value)
        }.first
        
        guard case .None = validationFailure else {
            self.errorText = validationFailure!.errorText
            return false
        }
        
        return true
    }
}

//MARK: - FormInputValidationRule

class FormInputValidationRule<T> {
    
    var errorText: String
    
    var validationClosure: ((T) -> Bool)
    
    init(failureText: String, validation: ((T) -> Bool)) {
        self.errorText = failureText
        self.validationClosure = validation
    }
    
    func validate(inputValue inputValue: T) -> Bool {
        return validationClosure(inputValue)
    }
}