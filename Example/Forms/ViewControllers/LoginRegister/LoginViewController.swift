//
//  LoginViewController.swift
//  Forms
//
//  Created by mrandall on 12/27/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import Forms

class LoginViewController: UIViewController, FormViewController {
    
    
    //MARK: - ViewModel
    
    lazy var formViewModel: FormViewModel = {
        return LoginFormViewModel()
    }()
    
    //MARK: - Subviews
    
    @IBOutlet weak var inputStackView: UIStackView!
    
    //MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create form from FormViewModel
        createFormInputs()
    }
    
    //MARK: - Actions
    
    @IBAction private func submitButtonTapped(sender: AnyObject?) {
        view.endEditing(true)
        formViewModel.submitForm()
    }
    
    @IBAction private func unwindFromRegistration(segue: UIStoryboardSegue) {}
}