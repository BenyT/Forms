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
    
    lazy var userNameInputViewModel: FormInputViewModel<String> = {
        let vm = FormInputViewModel(value: "", caption: "email or something")
        vm.placeholder = "userName"
        return vm
    }()
    
    lazy var passwordInputViewModel: FormInputViewModel<String> = {
        let vm = FormInputViewModel(value: "", caption: "")
        vm.placeholder = "password"
        return vm
    }()
    
    lazy var termsCheckboxInputViewModel: FormInputViewModel<Bool> = {
        let vm = FormInputViewModel(value: false, caption: "terms copy")
        return vm
    }()

    //NOTE: using AnyObject until swift supports covariance for generics
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
            
            if let viewModel = $0 as? FormInputViewModel<String> {
                return viewModel.validate()
            }
            
            if let viewModel = $0 as? FormInputViewModel<Bool> {
                return viewModel.validate()
            }
            
            return true
            
        }
        return invalidInputs.count == 0
    }
}