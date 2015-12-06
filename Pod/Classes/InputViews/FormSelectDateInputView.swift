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
public class FormSelectDateInputView: UIView, FormInputView, FormInputViewModelView, UITextFieldDelegate {
    
    //MARK: - FormInputViewModelView
    
    public var viewModel: FormInputViewModel<NSDate>? {
        didSet {
            bindViewModel()
        }
    }
    
    //MARK: - FormBaseTextInputView
    
    private lazy var formBaseTextInputView: FormBaseTextInputView = { [unowned self] in
        let ui = FormBaseTextInputView()
        self.addSubview(ui)
        return ui
    }()
    
    public var textField: UITextField {
        return formBaseTextInputView.textField
    }
    
    public var captionLabel: UILabel {
        return formBaseTextInputView.captionLabel
    }
    
    public var errorLabel: UILabel {
        return formBaseTextInputView.errorLabel
    }
    
    //manually added layout constraints
    private var layoutConstraints = [NSLayoutConstraint]()
    
    lazy public var datePicker: UIDatePicker = { [weak self] in
        let picker = UIDatePicker()
        picker.addTarget(self, action: InputSelector.DatePickerValueChanged.rawValue, forControlEvents: .ValueChanged)
        picker.maximumDate = NSDate()
        picker.datePickerMode = .Date
        return picker
    }()
    
    //MARK: - Init

    public func commonInit() {
        textField.delegate = self
        textField.inputView = datePicker
    }
    
    //MARK: - Layout
    
    override public func updateConstraints() {
        super.updateConstraints()
        
        //remove constaints added manaully
        layoutConstraints.forEach { $0.active = false }
        
        //layout subviews
        layoutConstraints = createConstraints(visualFormatting: [
            "H:|-(0)-[ui]-(0)-|",
            "V:|-(0)-[ui]-(0)-|",
            ],
            views: [
                "ui": formBaseTextInputView,
            ])
    }
    
    //MARK: - FormInputViewModelView
    
    //bind to viewModel
    public func bindViewModel() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        //viewModel.textObservable.observe { self.textField.text = $0 }
        viewModel.placeholderObservable.observe { self.textField.attributedPlaceholder = $0 }
        viewModel.captionObservable.observe { self.captionLabel.text = $0 }
        viewModel.errorTextObservable.observe { self.errorLabel.text = $0 }
        viewModel.returnKeyTypeObservable.observe { self.textField.returnKeyType = $0 }
    }
    
    override public func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }
    
    //MARK: - UITextFieldDelegate
    
    public func textFieldShouldClear(textField: UITextField) -> Bool {
        viewModel?.value = nil
        //viewModel?.displayValue = ""
        return true
    }
    
    //MARK: - Actions
    
    public func datePickerValueChanged(sender: AnyObject?) {
        viewModel?.value = datePicker.date
        textField.text = viewModel?.displayValue
    }
}

