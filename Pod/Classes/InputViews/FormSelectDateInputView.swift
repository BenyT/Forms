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
public class FormSelectDateInputView: FormBaseTextInputView, FormInputView, FormInputViewModelView, UITextFieldDelegate {
    
    public var viewModel: FormInputViewModel<NSDate>? {
        didSet {
            bindViewModel()
        }
    }
    
    lazy public var datePicker: UIDatePicker = { [weak self] in
        let picker = UIDatePicker()
        picker.addTarget(self, action: InputSelector.DatePickerValueChanged.rawValue, forControlEvents: .ValueChanged)
        picker.maximumDate = NSDate()
        picker.datePickerMode = .Date
        return picker
    }()
    
    //next input in form
    @IBOutlet public var nextInput: FormInputView? {
        didSet {
            textField.returnKeyType = .Next
        }
    }
    
    //MARK: - Init

    override public func commonInit() {
        super.commonInit()
        textField.delegate = self
        textField.inputView = datePicker
    }
    
    //MARK: - FormInputViewModelView
    
    //bind to viewModel
    public func bindViewModel() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        textField.placeholder = viewModel.placeholder
        //textField.text = viewModel.value
        textField.returnKeyType = viewModel.returnKeyType
        captionLabel.text = viewModel.caption
        errorLabel.text = viewModel.errorText ?? ""
    }
    
    override public func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }
    
    //MARK: - UITextFieldDelegate
    
    public func textFieldShouldClear(textField: UITextField) -> Bool {
        viewModel?.value = nil
        viewModel?.displayValue = ""
        return true
    }
    
    //MARK: - Actions
    
    public func datePickerValueChanged(sender: AnyObject?) {
        viewModel?.value = datePicker.date
        textField.text = viewModel?.displayValue
    }
}

