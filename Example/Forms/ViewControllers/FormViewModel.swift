//
//  FormViewModel.swift
//  Forms
//
//  Created by mrandall on 12/5/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation
import Forms

final class FormViewModel {
    
    //MARK: - Input View Models - Username and password
    
    lazy var userNameInputViewModel: FormInputViewModel<String> = { [unowned self] in
        let vm = FormInputViewModel(value: "")
        vm.placeholder = "* user name"
        vm.nextInputsViewModel = self.passwordInputViewModel
        vm.returnKeyType = .Next
        vm.autocorrectionType = .No
        
        vm.validationRules = [
            FormInputValidationRule(failureText: "Must be at least 8 characters long.") { inputValue -> Bool in
                return inputValue.characters.count > 7
            }
        ]
        
        return vm
    }()
    
    lazy var passwordInputViewModel: FormInputViewModel<String> = {
        let vm = FormInputViewModel(value: "")
        vm.placeholder = "* password"
        vm.returnKeyType = .Next
        vm.nextInputsViewModel = self.confirmPasswordInputViewModel
        vm.secureTextEntry = true
        vm.autocorrectionType = .No
        
        vm.validationRules = [
            FormInputValidationRule(failureText: "Must be at least 8 characters long.") { inputValue -> Bool in
                return inputValue.characters.count > 7
            }
        ]
        
        return vm
    }()
    
    lazy var confirmPasswordInputViewModel: FormInputViewModel<String> = { [unowned self] in
        let vm = FormInputViewModel(value: "")
        vm.placeholder = "* confirm password"
        vm.returnKeyType = .Next
        vm.nextInputsViewModel = self.dateSelectInputViewModel
        vm.autocorrectionType = .No
        vm.enabled = false
        
        vm.validationRules = [
            FormInputValidationRule(failureText: "Must match password value") { inputValue -> Bool in
                return inputValue == self.passwordInputViewModel.value
            }
        ]
        
        return vm
    }()
    
    //MARK: - Input View Models - User optional data
    
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()

    lazy var dateSelectInputViewModel: FormInputViewModel<NSDate> = { [unowned self] in
        
        let vm = FormInputViewModel<NSDate>(value: nil)
        vm.placeholder = "birthday"
        vm.caption = "Used to ... sed ut perspiciatis unde omnis iste"
        
        vm.displayValueMap = { value -> String in
            self.dateFormatter.stringFromDate(value)
        }
        
        return vm
    }()
    
    //MARK: - Input View Models - Address
    
    lazy var stateSelectInputViewModel: FormSelectInputViewModel<String> = { [unowned self] in
        
        let vm = FormSelectInputViewModel(options: ["test1", "test2", "test3"], value: nil)
        vm.placeholder = "* state"
        vm.pickerPlaceholder = "-- Please select a state -- "
        
        vm.validationRules = [
            FormInputValidationRule(failureText: "Please picker a date") { inputValue -> Bool in
                return inputValue != nil
            }
        ]
        
        vm.displayValueMap = { value -> String in
            return "\(value) is an option"
        }
        
        return vm
    }()
    
    
    lazy var termsCheckboxInputViewModel: FormInputViewModel<Bool> = {
        let vm = FormInputViewModel(value: false)
        
        vm.validationRules = [
            FormInputValidationRule(failureText: "Please agree to terms") { inputValue -> Bool in
                return inputValue == true
            }
        ]
        
        return vm
    }()

    //Order of form inputs
    //NOTE: using AnyObject type until Swift supports covariance for generics
    //Will need to cast to all necessary specialized FormInputViewModel types
    lazy var inputs: [AnyObject] = { [unowned self] in
        return [
            self.userNameInputViewModel,
            self.passwordInputViewModel,
            self.confirmPasswordInputViewModel,
            self.dateSelectInputViewModel,
            self.stateSelectInputViewModel,
            self.termsCheckboxInputViewModel
        ]
    }()
    
    //MARK: - Init
    
    init() {
        
        self.passwordInputViewModel.validObservable.observe {
            self.confirmPasswordInputViewModel.enabled = $0
        }        
    }
    
    //MARK: - View Actions Handlers
    
    func submitForm() {
     
        guard validate() == true else {
            return
        }
        
        submitFormRequest()
    }
    
    //MARK: - Validation
    
    private func validate() -> Bool {
        
        let invalidInputs = inputs.filter {
            
            //select input
            if let viewModel = $0 as? FormSelectInputViewModel<String> {
                return viewModel.validate()
            }
            
            //text inputs
            if let viewModel = $0 as? FormInputViewModel<String> {
                return viewModel.validate()
            }
            
            //select date inputs
            if let viewModel = $0 as? FormInputViewModel<NSDate> {
                return viewModel.validate()
            }
  
            //checkbox inputs
            if let viewModel = $0 as? FormInputViewModel<Bool> {
                return viewModel.validate()
            }
            
            return true
        }
        
        return invalidInputs.count == 0
    }
    
    //MARK: - API Integration
    
    private func submitFormRequest() {
    
    }
}