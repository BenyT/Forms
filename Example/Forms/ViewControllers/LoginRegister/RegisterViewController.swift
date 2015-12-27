//
//  FormViewController.swift
//  Forms
//
//  Created by mrandall on 12/05/2015.
//  Copyright (c) 2015 mrandall. All rights reserved.
//

import UIKit
import Forms

final class RegisterViewController: UIViewController, FormViewController, AnimateWithKeyboardFrameWillChangeNotificationHandler {

    //MARK: - ViewModel
    
    lazy var formViewModel: FormViewModel = {
        return RegistrationFormViewModel()
    }()
    
    //MARK: - Subviews
    
    @IBOutlet weak var inputStackView: UIStackView!
    @IBOutlet weak private var scrollContentView: UIView!
    private var scrollView: UIScrollView?
    
    //MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //playce content in scrollview
        scrollView = embedViewInScrollView(scrollContentView)
        scrollView?.keyboardDismissMode = .Interactive
        
        //create form from FormViewModel
        createFormInputs()
    
        //notification handlers
        self.startObservingKeyboardFrameChange()
    }
    
    //MARK: - Actions
    
    @IBAction private func submitButtonTapped(sender: AnyObject?) {
        view.endEditing(true)
        formViewModel.submitForm()
    }
    
    //MARK: - AnimateWithKeyboardFrameWillChange
    
    func animatateOnKeyboardWillChange(keyboardEndFrame: CGRect) {
        
        guard let scrollView = self.scrollView else { return }
        
        //update scrollIndicatorInsets.bottom and contentInset.bottom to equal keyboard height
        let bottomMargin = CGRectIntersection(keyboardEndFrame, view.frame).size.height
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(scrollView.scrollIndicatorInsets.top, 0, bottomMargin, 0)
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, bottomMargin, 0)
    }
}

