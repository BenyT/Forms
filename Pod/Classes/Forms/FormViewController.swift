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

public protocol FormViewController {
    
    //FormViewModel for VC
    var formViewModel: FormViewModel { get }
    
    //Stackview form input views are to be arrangedsubviews of
    var inputStackView: UIStackView! { get }
    
    //Create form input views in VC view heirachy
    //Calls addFormInputSubview unless implimented
    func createFormInputs()
    
    // Creates from form inputviews
    func addFormInputSubviews(
        forInputViewModels inputViewModels: [AnyObject],
        inStackView formStackView: UIStackView
    )
}


public extension FormViewController where Self: UIViewController {

    //MARK: - Create FormInputViews from FormInputViewModels
    
    func createFormInputs() {
        addFormInputSubviews(forInputViewModels: formViewModel.inputs, inStackView: inputStackView)
    }
    
    //Create form inputs as arranged subviews of formStackView
    func addFormInputSubviews(
        forInputViewModels inputViewModels: [AnyObject],
        inStackView formStackView: UIStackView
    ) {
        
        //create and append a FormInputView for each FormInputViewModelProtocol
        //reverse to insert at zero index -
        //prepend all in viewModel input arranged subviews to existing arranged subviews
        inputViewModels.reverse().forEach {
            
            //select input with text
            if let viewModel = $0 as? FormSelectInputViewModel<String> {
                let selectInputView = FormSelectInputView(withViewModel: viewModel)
                
                viewModel.focusedObservable.observe {
                    
                    if $0 == true {
                        selectInputView.themeViewFocused()
                    } else {
                        selectInputView.themeView()
                    }
                }
                
                formStackView.insertArrangedSubview(selectInputView, atIndex: 0)
                return
            }
            
            //text inputs
            if let viewModel = $0 as? FormInputViewModel<String> {
                let textInputView = FormTextInputView(withViewModel: viewModel)
                
                viewModel.focusedObservable.observe {
                    
                    if $0 == true {
                        textInputView.themeViewFocused()
                    } else {
                        textInputView.themeView()
                    }
                }
                
                viewModel.enabledObservable.observe {
                    textInputView.hidden = !$0
                }
                
                formStackView.insertArrangedSubview(textInputView, atIndex: 0)
                return
            }
            
            //select data inputs
            if let viewModel = $0 as? FormInputViewModel<NSDate> {
                let selectDateInputView = FormSelectDateInputView(withViewModel: viewModel)
                
                viewModel.focusedObservable.observe {
                    
                    if $0 == true {
                        selectDateInputView.themeViewFocused()
                    } else {
                        selectDateInputView.themeView()
                    }
                }
                
                formStackView.insertArrangedSubview(selectDateInputView, atIndex: 0)
                return
            }
            
            //checkbox inputs
            if let viewModel = $0 as? FormInputViewModel<Bool> {
                let checkboxInputView = FormCheckboxInputView(withViewModel: viewModel)
                checkboxInputView.themeView()
                formStackView.insertArrangedSubview(checkboxInputView, atIndex: 0)
                return
            }
        }
    }
}
