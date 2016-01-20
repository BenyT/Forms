//
//  FormSelectDateInputView.swift
//
//  The MIT License (MIT)
//
//  Created by mrandall on 11/30/15.
//  Copyright © 2015 mrandall. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
import UIKit

private enum InputSelector: Selector {
    case DatePickerValueChanged = "datePickerValueChanged:"
}

//@IBDesignable
public class FormSelectDateInputView: UIView, KeyboardFormIputView {
    
    override class public func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    //MARK: - FormInputView
    
    public var identifier: String
//
//    public var theme: FormInputViewTheme = DefaultFormInputViewTheme()
//    
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
        ui.textField.inputView = self.datePicker
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

    public convenience init(withViewModel viewModel: FormInputViewModel<NSDate>) {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        identifier = viewModel.identifier
        self.viewModel = viewModel
        commonInit()
    }
    
    override public init(frame: CGRect) {
        self.identifier = NSUUID().UUIDString
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.identifier = NSUUID().UUIDString
        super.init(coder: aDecoder)
        commonInit()
    }
    
//    override public func prepareForInterfaceBuilder() {
//        commonInit()
//        addSubviewConstraints()
//    }
    
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
        UIView.createConstraints(visualFormatting: [
            "H:|-(0)-[ui]-(0)-|",
            "V:|-(0)-[ui]-(0)-|",
            ],
            views: [
                "ui": formBaseTextInputView,
            ])
        
        invalidateIntrinsicContentSize()
    }
    
    //MARK: - UIResponder
    
    override public func resignFirstResponder() -> Bool {
        return formBaseTextInputView.textField.resignFirstResponder()
    }
    
    override public func isFirstResponder() -> Bool {
        return formBaseTextInputView.textField.isFirstResponder()
    }
    
    //MARK: - Actions
    
    public func datePickerValueChanged(sender: AnyObject?) {
        viewModel?.value = datePicker.date
        textField.text = viewModel?.displayValue
    }
}

//MARK: - FormInputViewModelView

extension FormSelectDateInputView: FormInputViewModelView {
    
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
}

//MARK: - UITextFieldDelegate

extension FormSelectDateInputView: UITextFieldDelegate {
    
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
}

