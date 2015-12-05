//
//  FormSelectDateInputView.swift
//
//  Created by mrandall on 11/30/15.
//  Copyright © 2015 mrandall. All rights reserved.
//

import UIKit

private enum InputSelector: Selector {
    case DatePickerValueChanged = "datePickerValueChanged:"
}


@IBDesignable
class FormSelectDateInputView: FormBaseTextInputView, FormInputView, FormInputViewModelView, UITextFieldDelegate {
    
    var viewModel: FormInputViewModel<NSDate>? {
        didSet {
            bindViewModel()
        }
    }
    
    lazy var datePicker: UIDatePicker = { [weak self] in
        let picker = UIDatePicker()
        picker.addTarget(self, action: InputSelector.DatePickerValueChanged.rawValue, forControlEvents: .ValueChanged)
        picker.maximumDate = NSDate()
        picker.datePickerMode = .Date
        return picker
    }()
    
    //next input in form
    @IBOutlet var nextInput: FormInputView? {
        didSet {
            textField.returnKeyType = .Next
        }
    }
    
    //MARK: - Init

    override func commonInit() {
        super.commonInit()
        textField.delegate = self
        textField.inputView = datePicker
    }
    
    //MARK: - FormInputViewModelView
    
    //bind to viewModel
    func bindViewModel() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        textField.placeholder = viewModel.placeholder
        //textField.text = viewModel.value
        textField.returnKeyType = viewModel.returnKeyType
        captionLabel.text = viewModel.caption
        errorLabel.text = viewModel.errorText ?? ""
    }
    
    override func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        viewModel?.value = nil
        viewModel?.displayValue = ""
        return true
    }
    
    //MARK: - Actions
    
    func datePickerValueChanged(sender: AnyObject?) {
        viewModel?.value = datePicker.date
        textField.text = viewModel?.displayValue
    }
}

