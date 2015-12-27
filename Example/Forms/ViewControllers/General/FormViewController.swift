//
//  FormViewController.swift
//  Forms
//
//  Created by mrandall on 12/27/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import Forms

protocol FormViewController {
    
    //FormViewModel for VC
    var formViewModel: FormViewModel { get }
    
    //Stackview form input views are to be arrangedsubviews of
    var inputStackView: UIStackView! { get }
    
    //Create form input views in VC view heirachy
    //Calls addFormInputSubview unless implimented
    func createFormInputs()
    
    // Creates from form inputviews
    func addFormInputSubview(forInputViewModels inputViewModels: [AnyObject], inStackView formStackView: UIStackView)
}

extension FormViewController where Self: UIViewController {
    
    //MARK: - Create FormInputViews from FormInputViewModels
    
    func createFormInputs() {
        addFormInputSubview(forInputViewModels: formViewModel.inputs, inStackView: inputStackView)
    }
    
    //Create form inputs as arranged subviews of formStackView
    func addFormInputSubview(forInputViewModels inputViewModels: [AnyObject], inStackView formStackView: UIStackView) {
        
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
                textInputView.themeView()
                
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
