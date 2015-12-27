//
//  FormViewModel.swift
//  Forms
//
//  Created by mrandall on 12/27/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Forms

protocol FormViewModel {
    
    //Ordered FormInputViewModel objects
    //NOTE: using AnyObject type until Swift supports covariance for generics
    //Will require casting to all necessary specialized FormInputViewModel types
    //Not supported as of Swift 2.1
    var inputs: [AnyObject] { get }
    
    //Validate inputs
    //
    // - Returns Bool if valid
    func validate() -> Bool
    
    //Submit form using Application specific logic
    //Validate in the process if desired
    func submitForm()
}

extension FormViewModel {
    
    func validate() -> Bool {
        
        let invalidInputs = inputs.filter {
            
            //Requires generic covariance support
            //Not supported as of Swift 2.1
            //if let viewModel = $0 as? FormInputValidatable { }
            
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
}