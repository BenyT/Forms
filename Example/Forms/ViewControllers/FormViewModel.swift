//
//  FormViewModel.swift
//  Forms
//
//  Created by mrandall on 12/5/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation
import Forms

class FormViewModel {
    
    lazy var userNameInputViewModel: FormInputViewModel<String> = { [unowned self] in
        let vm = FormInputViewModel(value: "", caption: "Username or email")
        vm.validationRules = [
            FormInputValidationRule(failureText: "Must be at least 8 characters long.") { inputValue -> Bool in
                return inputValue.characters.count > 7
            }
        ]
        vm.placeholder = "userName"
        vm.nextInputsViewModel = self.passwordInputViewModel
        vm.returnKeyType = .Next
        vm.autocorrectionType = .No
        return vm
    }()
    
    lazy var passwordInputViewModel: FormInputViewModel<String> = {
        let vm = FormInputViewModel(value: "", caption: "")
        vm.validationRules = [
            FormInputValidationRule(failureText: "Must be at least 8 characters long.") { inputValue -> Bool in
                return inputValue.characters.count > 7
            }
        ]
        vm.placeholder = "password"
        vm.returnKeyType = .Next
        vm.secureTextEntry = true
        vm.autocorrectionType = .No
        return vm
    }()
    
    lazy var termsCheckboxInputViewModel: FormInputViewModel<Bool> = {
        let vm = FormInputViewModel(value: false, caption: "terms copy")
        vm.validationRules = [
            FormInputValidationRule(failureText: "Must agree to terms") { inputValue -> Bool in
                return inputValue == true
            }
        ]
        return vm
    }()

    //NOTE: using AnyObject until Swift supports covariance for generics
    //Will need to cast to all necessary specialized FormInputViewModel types
    lazy var inputs: [AnyObject] = { [unowned self] in
        return [
            self.userNameInputViewModel,
            self.passwordInputViewModel,
            self.termsCheckboxInputViewModel
        ]
    }()
    
    //MARK: - View Actions
    
    func submitForm() {
     
        guard validate() == true else {
            return
        }
        
        //Submission logic
    }
    
    //MARK: - Validation
    
    private func validate() -> Bool {
        
        let invalidInputs = inputs.filter {
            
            //text inputs
            if let viewModel = $0 as? FormInputViewModel<String> {
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
}