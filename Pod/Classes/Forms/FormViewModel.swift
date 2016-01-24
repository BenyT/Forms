//
//  FormViewModel.swift
//  Forms
//
//  The MIT License (MIT)
//
//  Created by mrandall on 12/02/15.
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

public class FormViewModelValidator {
    
    //Validates self.iputs or inputs provided as inputs parameter
    //
    // - Parameter inputs: [FormInputViewModelProtocol]
    // - Returns Bool
    public static func validate(inputs inputs: [FormInputViewModelObservable]) -> Bool {
        
        let invalidInputs = inputs.filter {
            
            //Requires generic covariance / dynamic dispatch support
            //Not supported as of Swift 2.1
            //if let viewModel = $0 as? FormInputValidatable { } is not supported
            
            //select textinput
            if let viewModel = $0 as? FormSelectInputViewModel<String> {
                return viewModel.validate()
            }
            
            //select bool input
            if let viewModel = $0 as? FormSelectInputViewModel<Bool> {
                return viewModel.validate()
            }
            
            //select date
            if let viewModel = $0 as? FormSelectInputViewModel<NSDate> {
                return viewModel.validate()
            }
            
            //select any
            if let viewModel = $0 as? FormSelectInputViewModel<Any> {
                return viewModel.validate()
            }
            
            //date inputs
            if let viewModel = $0 as? FormInputViewModel<NSDate> {
                return viewModel.validate()
            }
            
            //text inputs
            if let viewModel = $0 as? FormInputViewModel<String> {
                return viewModel.validate()
            }

            //double inputs
            if let viewModel = $0 as? FormInputViewModel<Double> {
                return viewModel.validate()
            }
            
            //int inputs
            if let viewModel = $0 as? FormInputViewModel<Int> {
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