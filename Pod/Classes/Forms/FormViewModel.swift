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

public protocol FormViewModel {
    
    //Ordered FormInputViewModel objects
    //NOTE: using FormInputViewModelProtocol type until Swift supports covariance for generics
    //Will require casting to all necessary specialized FormInputViewModel types
    //Not supported as of Swift 2.1
    var inputs: [FormInputViewModelProtocol] { get }
    
    //Validate inputs
    //
    // - Returns Bool if valid
    func validate() -> Bool
    
    //Submit form using Application specific logic
    //Validate in the process if desired
    func submitForm()
}

func ==(lhs: FormViewModel, rhs: FormViewModel) -> Bool {
    return lhs == rhs
}

public extension FormViewModel {
    
    //TODO: consider inheritance or class to allow validate to be extended
    
    // If your form has custom input view models (FormInputViewModel<T>) you will most likely need to override this method
    public func validate() -> Bool {
        
        let invalidInputs = inputs.filter {
            
            //Requires generic covariance / dynamic dispatch support
            //Not supported as of Swift 2.1
            //if let viewModel = $0 as? FormInputValidatable { } is not supported
            
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
    
    subscript(identifier: String) -> FormInputViewModelProtocol? {
        return inputs.filter {
            $0.identifier == identifier
        }.first
    }
}