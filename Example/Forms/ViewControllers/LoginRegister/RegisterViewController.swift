//
//  FormViewController.swift
//  Forms
//
//  Created by mrandall on 12/05/2015.
//  Copyright (c) 2015 mrandall. All rights reserved.
//

import UIKit
import Forms

final class RegisterViewController: UIViewController {

    //MARK: - ViewModel
    
    lazy var formViewModel: RegistrationFormViewModel = {
        return RegistrationFormViewModel()
    }()
    
    //MARK: - Subviews
    
    var inputsViewsByIdentifier: [String: FormInputView] = [:]
    
    @IBOutlet weak var inputsStackView: UIStackView!
    @IBOutlet weak private var scrollContentView: UIView!
    private var scrollView: UIScrollView?
    
    var inputs: [FormInputView] = []
    
    //MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //playce content in scrollview
        scrollView = embedViewInScrollView(scrollContentView)
        scrollView?.keyboardDismissMode = .Interactive
        
        //create form from FormViewModel
        createForm()
        bindFormViewModel()
        
        //notification handlers
        startObservingKeyboardFrameChange()
    }
    
    func createForm()  {
        
        inputsViewsByIdentifier = [:]
        
        //create and append a FormInputView for each FormInputViewModelProtocol
        //reverse to insert at zero index -
        //prepend all in viewModel input arranged subviews to existing arranged subviews
        formViewModel.inputs.reverse().forEach { viewModel in
            
            guard
                let input = FormFactory.createFormInputView(withInputViewModel: viewModel),
                let inputView = input as? UIView
                else { return }
            
            inputsViewsByIdentifier[input.identifier] = input
            
            inputsStackView.insertArrangedSubview(inputView, atIndex: 0)
        }
    }
    
    func bindFormViewModel() {
        
        formViewModel.inputs.map { $0 }.forEach { viewModel in
            
            if let view =  inputsViewsByIdentifier[viewModel.identifier] as? KeyboardFormIputView {
                
                viewModel.focusedObservable.observe {
                    
                    if $0 == true {
                        view.themeViewFocused()
                    } else {
                        view.themeView()
                    }
                }
                
                //Checkbox
                //Date select
                if let view =  inputsViewsByIdentifier[viewModel.identifier] as? ButtonFormIputView {
                    view.themeView()
                }
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction private func submitButtonTapped(sender: AnyObject?) {
        view.endEditing(true)
        //formViewModel.submitForm()
    }
}

//MARK: - AnimateWithKeyboardFrameWillChange

extension RegisterViewController: AnimateWithKeyboardFrameWillChangeNotificationHandler {

    func animatateOnKeyboardWillChange(keyboardEndFrame: CGRect) {
        
        guard let scrollView = self.scrollView else { return }
        
        //update scrollIndicatorInsets.bottom and contentInset.bottom to equal keyboard height
        let bottomMargin = CGRectIntersection(keyboardEndFrame, view.frame).size.height
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(scrollView.scrollIndicatorInsets.top, 0, bottomMargin, 0)
        scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, 0, bottomMargin, 0)
    }
}

