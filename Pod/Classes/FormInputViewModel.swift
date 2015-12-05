//
//  FormInputViewModel.swift
//
//  Created by mrandall on 10/27/15.
//  Copyright © 2015 mrandall. All rights reserved.
//

import Foundation
import UIKit

enum FormInputViewModelProperty: String {
    case Value
    case ReturnKeyType
    case Placeholder
    case Caption
    case DisplayValue
}

protocol FormInputViewModelDelegate: class {
    
    // ViewModel property was updated
    //
    // - Parameter viewModel: FormInputViewModel
    // - Parameter propertyNameUpdated: String name of instance property
    // - Parameter newValue: value of property
    func viewModel<T: Any>(viewModel: FormInputViewModel<T>, propertyNameUpdated: String, newValue: Any)
}

class FormInputViewModel<T>: FormInputValidatable {
    
    //typealias DateType
    
    //delegate
    weak var delegate: FormInputViewModelDelegate?
    
    //textfield text
    var value: T? {
        didSet {
            delegateUpdateForKey(FormInputViewModelProperty.Value.rawValue, value: value)
        }
    }
    
    //textfield text
    var displayValue: String = "" {
        didSet {
            delegateUpdateForKey(FormInputViewModelProperty.DisplayValue.rawValue, value: displayValue)
        }
    }
    
    //caption label text
    var caption: String = "" {
        didSet {
            delegateUpdateForKey(FormInputViewModelProperty.Caption.rawValue, value: caption)
        }
    }
    
    //textfield placeholder
    var placeholder: String = "" {
        didSet {
            delegateUpdateForKey(FormInputViewModelProperty.Placeholder.rawValue, value: placeholder)
        }
    }
    
    //textfield return key
    var returnKeyType: UIReturnKeyType  = .Default {
        didSet {
            delegateUpdateForKey(FormInputViewModelProperty.ReturnKeyType.rawValue, value: returnKeyType)
        }
    }
    
    //MARK: - FormInputValidatable
    
    //whether input is valid
    var valid = false {
        didSet {
            delegateUpdateForKey(FormInputValidatableProperty.Valid.rawValue, value: valid)
        }
    }
    
    //error text if not value
    var errorText: String? {
        didSet {
            delegateUpdateForKey(FormInputValidatableProperty.ErrorText.rawValue, value: errorText)
        }
    }
    
    var validationRules = [FormInputValidationRule<T>]()
    
    var inputValueToValidate: T? { return self.value }
    
    //MARK: - Init
    
    // Init
    //
    // - Parameter value: T
    init(value: T, caption: String = "") {
        self.value = value
        self.displayValue = self.value as? String ?? ""
    }

    //MARK: - Delegation
    
    // Call delegate update method if delegate is not nil
    //
    // - Parameter key: String
    // - Paramater value: Any
    func delegateUpdateForKey(key: String, value: Any) {
        delegate?.viewModel(self, propertyNameUpdated: key, newValue: value)
    }
}