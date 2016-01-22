//
//  FormViewModel.swift
//  Forms
//
//  Created by mrandall on 12/5/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation
import Forms

final class RegistrationFormViewModel: FormViewModel {
    
    //MARK: - Input View Models - Username and password
    
    lazy var userNameInputViewModel: FormInputViewModel<String> = { [unowned self] in
        
        let vm = FormInputViewModel(identifier: "username", value: "")
        vm.placeholder = "* user name"
        vm.caption = "Users will identify one another by username"
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
        
        let vm = FormInputViewModel(identifier: "password", value: "")
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
        
        let vm = FormInputViewModel(identifier: "confirmPassword", value: "")
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
        
        let vm = FormInputViewModel<NSDate>(identifier: "birthday", value: nil)
        vm.placeholder = "birthday"
        vm.caption = "Why we ask: Receive special promotions on your birthday"
        
        vm.displayValueMap = { value -> String in
            self.dateFormatter.stringFromDate(value)
        }
        
        return vm
    }()
    
    //MARK: - Input View Models - Address
    
    lazy var stateSelectInputViewModel: FormSelectInputViewModel<String> = { [unowned self] in
        
        let vm = FormSelectInputViewModel(identifier: "state", options: ["Alabama", "Minnesota", "Washington"], value: nil)
        vm.placeholder = "* state"
        vm.pickerPlaceholder = "-- Please select a state -- "
        
        vm.validationRules = [
            FormInputValidationRule(failureText: "Please pick a state") { inputValue -> Bool in
                return inputValue != nil
            }
        ]
        
        vm.displayValueMap = { value -> String in
            return "\(value) is an option"
        }
        
        return vm
    }()
    
    lazy var termsCheckboxInputViewModel: FormInputViewModel<Bool> = {
        
        let vm = FormInputViewModel(identifier: "terms", value: false)
        vm.caption = "I agree to your terms"
        vm.inputViewLayout.subviewSpacing = 10
        
        vm.validationRules = [
            FormInputValidationRule(failureText: "Please agree to terms") { inputValue -> Bool in
                return inputValue == true
            }
        ]
        
        return vm
    }()

    //MARK: - FormViewModel
    
    lazy var inputs: [FormInputViewModelObservable] = { [unowned self] in
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
        bindFormInputs()
    }
    
    //MARK: - Bind ViewModels
    
    private func bindFormInputs() {
        
        self.passwordInputViewModel.validObservable.observe {
            self.confirmPasswordInputViewModel.enabled = $0
            self.passwordInputViewModel.nextInputsViewModel = $0 ? self.confirmPasswordInputViewModel : self.dateSelectInputViewModel
        }
    }

    //MARK: - View Actions Handlers
    
    func submitForm() {
     
        guard FormViewModelValidator.validate(inputs: inputs) == true else {
            return
        }
        
        submitFormRequest()
    }
    
    //MARK: - API Integration
    
    private func submitFormRequest() {
        //APPLICATION SPECIFIC
    }
}