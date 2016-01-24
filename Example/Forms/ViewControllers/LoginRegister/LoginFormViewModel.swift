//
//  LoginFormViewModel.swift
//  Forms
//
//  Created by mrandall on 12/27/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation

import Forms

final class LoginFormViewModel {
    
    //MARK: - Input View Models
    
    lazy var userNameInputViewModel: FormInputViewModel<String> = { [unowned self] in
        let vm = FormInputViewModel(identifier: "username", value: "")
        vm.placeholder = "* user name"
        vm.nextInputsViewModel = self.passwordInputViewModel
        vm.returnKeyType = .Next
        vm.autocorrectionType = .No
        
        vm.validationRules = [
            FormInputValidationRule(failureText: "Username is required") { inputValue -> Bool in
                return inputValue.characters.count > 7
            }
        ]
        
        return vm
    }()
    
    lazy var passwordInputViewModel: FormInputViewModel<String> = {
        let vm = FormInputViewModel(identifier: "password", value: "")
        vm.placeholder = "* password"
        vm.returnKeyType = .Go
        vm.secureTextEntry = true
        vm.autocorrectionType = .No
        
        vm.validationRules = [
            FormInputValidationRule(failureText: "Password is required") { inputValue -> Bool in
                return inputValue.characters.count > 7
            }
        ]
        
        return vm
    }()

    //MARK: - FormViewModel
    
    lazy var inputs: [FormInputViewModelObservable] = { [unowned self] in
        return [
            self.userNameInputViewModel,
            self.passwordInputViewModel
        ]
    }()
    
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