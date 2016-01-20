//
//  FormViewController.swift
//  Forms
//
//  The MIT License (MIT)
//
//  Created by mrandall on 12/27/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
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

import UIKit

public protocol FormViewController{
    
//    var inputsByIdentifier: [String: FormInputView] { get set }
    
    //FormViewModel for VC
    var formViewModel: FormViewModel { get  }
    
    //Creates view for each viewModel and add to inputsStackView
    func createForm()
}

public class FormFactory {

    public class func createFormInputView(withInputViewModel inputViewModel: FormInputViewModelProtocol) -> FormInputView? {

        //select input with text
        if let viewModel = inputViewModel as? FormSelectInputViewModel<String> {
            let selectInputView = FormSelectInputView(withViewModel: viewModel)
            return selectInputView
        }
        
        //text inputs
        if let viewModel = inputViewModel as? FormInputViewModel<String> {
            let textInputView = FormTextInputView(withViewModel: viewModel)
            return textInputView
        }
        
        //data inputs
        if let viewModel = inputViewModel as? FormInputViewModel<NSDate> {
            let selectDateInputView = FormSelectDateInputView(withViewModel: viewModel)
            return selectDateInputView
        }
        
        //checkbox inputs
        if let viewModel = inputViewModel as? FormInputViewModel<Bool> {
            let checkboxInputView = FormCheckboxInputView(withViewModel: viewModel)
            return checkboxInputView
        }
     
        return nil
    }
}
