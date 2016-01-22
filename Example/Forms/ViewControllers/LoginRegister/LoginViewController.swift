//
//  LoginViewController.swift
//  Forms
//
//  Created by mrandall on 12/27/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import Forms

class LoginViewController: UIViewController {

    //MARK: - ViewModel
    
    lazy var formViewModel: LoginFormViewModel = {
        return LoginFormViewModel()
    }()
    
    //MARK: - Subviews
    
    var inputsViewsByIdentifier: [String: FormInputView] = [:]
    
    @IBOutlet weak var inputsStackView: UIStackView!

    //MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create form from FormViewModel
        createForm()
        bindFormViewModel()
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
        
        formViewModel.inputs.map { $0.identifier }.forEach {
            
            if
                let viewModel = self.formViewModel[$0],
                let view =  inputsViewsByIdentifier[$0] as? KeyboardFormIputView
            {
                viewModel.focusedObservable.observe {
                    
                    if $0 == true {
                        view.themeViewFocused()
                    } else {
                        view.themeView()
                    }
                }
                
                //Checkbox
                //Date select
                if let view =  inputsViewsByIdentifier[$0] as? ButtonFormIputView {
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
    
    @IBAction private func unwindFromRegistration(segue: UIStoryboardSegue) {}
}