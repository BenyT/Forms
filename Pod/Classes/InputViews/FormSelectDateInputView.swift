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
    
    override class public func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    //MARK: - FormInputViewModelView
    
    public var viewModel: FormInputViewModel<NSDate>? {
        didSet {
            bindViewModel()
        }
    }
    
    //MARK: - Layout Configuration
    
    public var inputViewLayout: InputViewLayout = InputViewLayout() {
        didSet {
            formBaseTextInputView.inputViewLayout = inputViewLayout
        }
    }

    
    //MARK: - Subviews
    
    private lazy var formBaseTextInputView: FormBaseTextInputView<NSDate> = { [unowned self] in
        let ui = FormBaseTextInputView<NSDate>()
        ui.subviewOrder = self.inputViewLayout.subviewOrder
        ui.textField.delegate = self
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

    convenience public init(withViewModel viewModel: FormInputViewModel<NSDate>) {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.viewModel = viewModel
        commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public func prepareForInterfaceBuilder() {
        commonInit()
        addSubviewConstraints()
    }
    
    public func commonInit() {
        bindViewModel()
    }
    
    //MARK: - Layout
    
    override public func updateConstraints() {
        addSubviewConstraints()
        super.updateConstraints()
    }
    
    override public func intrinsicContentSize() -> CGSize {
        return formBaseTextInputView.intrinsicContentSize()
    }
    
    //MARK: - Add Subviews
    
    private var didAddSubviewConstriants = false
    
    private func addSubviewConstraints() {
        
        guard didAddSubviewConstriants == false else {
            return
        }
        
        didAddSubviewConstriants = true
        
        //layout subviews
        createConstraints(visualFormatting: [
            "H:|-(0)-[ui]-(0)-|",
            "V:|-(0)-[ui]-(0)-|",
            ],
            views: [
                "ui": formBaseTextInputView,
            ])
        
        invalidateIntrinsicContentSize()
    }
    
    //MARK: - FormInputViewModelView
    
    //bind to viewModel
    public func bindViewModel() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        formBaseTextInputView.bindViewModel(viewModel)
        
        viewModel.valueObservable.observe {
            if let value = $0 {
                self.datePicker.date = value
            }
        }
    }
    
    //MARK: - UIResponder
    
    override public func resignFirstResponder() -> Bool {
        return formBaseTextInputView.textField.resignFirstResponder()
    }
    
    override public func isFirstResponder() -> Bool {
        return formBaseTextInputView.textField.isFirstResponder()
    }
    
    //MARK: - UITextFieldDelegate
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        viewModel?.focused = true
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        viewModel?.focused = false
    }
    
    public func textFieldShouldClear(textField: UITextField) -> Bool {
        viewModel?.value = nil
        return true
    }
    
    //MARK: - Actions
    
    public func datePickerValueChanged(sender: AnyObject?) {
        viewModel?.value = datePicker.date
        textField.text = viewModel?.displayValue
    }
}

