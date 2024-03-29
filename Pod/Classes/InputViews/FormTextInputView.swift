//
//  FormTextInputView.swift
//
//  The MIT License (MIT)
//
//  Created by mrandall on 10/27/15.
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

public class FormTextInputView<T>: UIView, KeyboardFormIputView, FormInputViewModelView, UITextFieldDelegate {
    
    override class public func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    //MARK: - FormInputViewModelView Properties
    
    public var viewModel: FormInputViewModel<T>? {
        didSet {
            bindViewModel()
        }
    }
    
    //MARK: - FormInputView
    
    public var identifier: String
    
    //MARK: - Layout Configuration
    
    public var inputViewLayout: InputViewLayout = InputViewLayout() {
        didSet {
            formBaseTextInputView.inputViewLayout = inputViewLayout
        }
    }
    
    //MARK: - Subviews
    
    private lazy var formBaseTextInputView: FormBaseTextInputView<T> = { [unowned self] in
        let ui = FormBaseTextInputView<T>()
        ui.textField.delegate = self
        self.addSubview(ui)
        return ui
    }()
    
    public var textField: UITextField {
        return formBaseTextInputView.textField
    }
    
    public var textFieldReturnKeyTapped: ((UITextField) -> Void)?
    
    public var captionLabel: UILabel {
        return formBaseTextInputView.captionLabel
    }
    
    public var errorLabel: UILabel {
        return formBaseTextInputView.errorLabel
    }
    
    //manually added layout constraints
    private var layoutConstraints = [NSLayoutConstraint]()
    
    //MARK: - Init
    
    public convenience init(withViewModel viewModel: FormInputViewModel<T>) {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        identifier = viewModel.identifier
        self.viewModel = viewModel
        inputViewLayout = viewModel.inputViewLayout
        formBaseTextInputView.inputViewLayout = viewModel.inputViewLayout
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
    
    //MARK: - UIResponder
    
    override public func resignFirstResponder() -> Bool {
        return formBaseTextInputView.textField.resignFirstResponder()
    }
    
    override public func isFirstResponder() -> Bool {
        return formBaseTextInputView.textField.isFirstResponder()
    }

    //MARK: - FormInputViewModelView

    //bind to viewModel
    public func bindViewModel() {
        guard let viewModel = self.viewModel else { return }
        formBaseTextInputView.bindViewModel(viewModel)
        viewModel.hiddenObservable.observe { self.hidden = $0 }
    }

    //MARK: - UITextFieldDelegate

    public func textFieldDidBeginEditing(textField: UITextField) {
        viewModel?.focused = true
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        viewModel?.focused = false
    }
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if var nextInput = viewModel?.nextInputsViewModel {
            viewModel?.focused = false
            nextInput.focused = true
        }
        
        //Consider using an EventProducer
        textFieldReturnKeyTapped?(textField)
        
        return true
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //TODO: review this and how this can work with displayValueMap so that input can better support any type of data based ViewModel
        guard let currentText = textField.text else { return true }
        let newText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        guard let newValue = newText as? T else { return true }
        viewModel?.value = newValue
        return false
    }
    
    public func textFieldShouldClear(textField: UITextField) -> Bool {
        viewModel?.value = nil
        return true
    }
}

//MARK: - Equatable

func ==<T>(lhs: FormTextInputView<T>, rhs: FormTextInputView<T>) -> Bool {
    return lhs.identifier == rhs.identifier
}


