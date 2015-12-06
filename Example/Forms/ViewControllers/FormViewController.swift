//
//  FormViewController.swift
//  Forms
//
//  Created by mrandall on 12/05/2015.
//  Copyright (c) 2015 mrandall. All rights reserved.
//

import UIKit
import Forms

final class FormViewController: UIViewController {

    //MARK: - ViewModel
    
    lazy var viewModel: FormViewModel = {
        return FormViewModel()
    }()
    
    //MARK: - Subviews
    
    @IBOutlet private weak var formStackView: UIStackView! {
        didSet {
            formStackView.layoutMargins = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
            formStackView.layoutMarginsRelativeArrangement = true
            formStackView.spacing = 20.0
        }
    }
    
    //MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create form
        createFormFromViewModel()
    }
    
    //MARK: - Actions
    
    @IBAction private func submitButtonTapped(sender: AnyObject?) {
        view.endEditing(true)
        viewModel.submitForm()
    }
    
    //MARK: - Update View
    
    //Create form inputs as arranged subviews of formStackView
    private func createFormFromViewModel() {
        
        //create and append a FormInputView for each FormInputViewModelProtocol
        //reverse to insert at zero index -
        //prepend all in viewModel input arranged subviews to existing arranged subviews
        viewModel.inputs.reverse().forEach {
            
            //select input
            if let viewModel = $0 as? FormSelectInputViewModel<String> {
                let selectInputView = FormSelectInputView(withViewModel: viewModel)
                
                viewModel.isFirstResponderObservable.observe {
                    
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
                
                viewModel.isFirstResponderObservable.observe {
                    
                    if $0 == true {
                        textInputView.themeViewFocused()
                    } else {
                        textInputView.themeView()
                    }
                }
                
                formStackView.insertArrangedSubview(textInputView, atIndex: 0)
                return
            }
            
            //select data inputs
            if let viewModel = $0 as? FormInputViewModel<NSDate> {
                let selectDateInputView = FormSelectDateInputView(withViewModel: viewModel)
                
                viewModel.isFirstResponderObservable.observe {
                    
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

