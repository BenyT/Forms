//
//  FormSelectInputView.swift
//
//  The MIT License (MIT)
//
//  Created by mrandall on 12/05/15.
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

public class FormSelectInputView<T>: UIView, KeyboardFormIputView, FormInputViewModelView, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, FormInputViewModelObservable {

    override class public func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    //MARK: - FormInputView
    
    public var identifier: String

    //MARK: - FormInputViewModelView
    
    public var viewModel: FormInputViewModel<T> {
        didSet {
            bindViewModel()
        }
    }
    
    override public var focused: Bool {
        set { viewModel.focused = newValue }
        get { return viewModel.focused }
    }
    
    //MARK: - Layout Configuration
        
    public var inputViewLayout: InputViewLayout = InputViewLayout() {
        didSet {
            formBaseTextInputView.inputViewLayout = inputViewLayout
        }
    }

    
    //MARK: - Subviews
    
    private lazy var formBaseTextInputView: FormBaseTextInputView<T> = { [unowned self] in
        let ui = FormBaseTextInputView<T>()
        ui.subviewOrder = self.inputViewLayout.subviewOrder
        ui.textField.inputView = self.pickerView
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
    
    //MARK: - Subviews
    
    lazy public var pickerView: UIPickerView = { [weak self] in
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
        }()
    
    //MARK: - Init
    
    public convenience init(withViewModel viewModel: FormSelectInputViewModel<T>) {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        identifier = viewModel.identifier
        self.viewModel = viewModel
        inputViewLayout = viewModel.inputViewLayout
        formBaseTextInputView.inputViewLayout = viewModel.inputViewLayout
        commonInit()
    }
    
    override public init(frame: CGRect) {
        self.identifier = NSUUID().UUIDString
        self.viewModel = FormInputViewModel(identifier: self.identifier)
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.identifier = NSUUID().UUIDString
        self.viewModel = FormInputViewModel(identifier: self.identifier)
        super.init(coder: aDecoder)
        commonInit()
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
        
        guard didAddSubviewConstriants == false else { return }
        
        didAddSubviewConstriants = true
        
        //layout subviews
        UIView.createConstraints(visualFormatting: [
            "H:|-(\(inputViewLayout.insets.left))-[ui]-(\(inputViewLayout.insets.right))-|",
            "V:|-(\(inputViewLayout.insets.top))-[ui]-(\(inputViewLayout.insets.bottom))-|",
            ],
            views: [
                "ui": formBaseTextInputView,
            ])
        
        invalidateIntrinsicContentSize()
    }
    
    //MARK: - FormInputViewModelView
    
    public func bindViewModel() {
        formBaseTextInputView.bindViewModel(viewModel)
        viewModel.hiddenObservable.observe { self.hidden = $0 }
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
        viewModel.focused = true
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        viewModel.focused = false
    }
    
    public func textFieldShouldClear(textField: UITextField) -> Bool {
        viewModel.value = nil
        return true
    }
    
    //MARK: - UIPickerViewDataSource
        
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        guard let viewModel = viewModel as? FormSelectInputViewModel else { return 0 }
        
        let placeholderOffset = (viewModel.pickerPlaceholder != nil) ? 1 : 0
        
        return viewModel.options.count + placeholderOffset
    }
    
    //MARK: - UIPickerViewDelegate
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard let viewModel = viewModel as? FormSelectInputViewModel else { return "" }
        
        if row == 0 && viewModel.pickerPlaceholder != nil {
            return viewModel.pickerPlaceholder
        }
        
        let placeholderOffset = (viewModel.pickerPlaceholder != nil) ? 1 : 0
        
        if let map = viewModel.displayValueMap {
            return map(viewModel.options[row - placeholderOffset])
        } else {
            return viewModel.options[row - placeholderOffset] as? String ?? ""
        }
    }

    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard let viewModel = viewModel as? FormSelectInputViewModel else { return }
        
        if row == 0 && viewModel.pickerPlaceholder != nil {
            viewModel.value = nil
            return
        }
        
        let placeholderOffset = (viewModel.pickerPlaceholder != nil) ? 1 : 0

        viewModel.value = viewModel.options[row - placeholderOffset]
    }
}

//MARK: - Equatable

func ==<T>(lhs: FormSelectInputView<T>, rhs: FormSelectInputView<T>) -> Bool {
    return lhs.identifier == rhs.identifier
}
