//
//  FormBaseTextInputView.swift
//
//  The MIT License (MIT)
//
//  Created by mrandall on 12/02/15.
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

//MARK: - Form Input Subviews

public protocol FormInputView: class {
    
    var identifier: String { get }
    
    //var theme: FormInputViewTheme { get set }
    
    var captionLabel: UILabel { get }
    
    var errorLabel: UILabel { get }
    
    func becomeFirstResponder() -> Bool
}

public protocol KeyboardFormIputView: FormInputView {
    var textField: UITextField { get }
}

public protocol ButtonFormIputView: FormInputView {
    var button: UIButton { get }
}

//MARK: - Form Input Subview Layout

public enum InputSubviews {
    case TextField
    case CaptionLabel
    case ErrorLabel
}

protocol FormBaseTextInputViewLayout {
    
    var inputLayoutAxis: UILayoutConstraintAxis { get set }
    
    var subviewSpacing: Double { get set }
    
    var subviewOrder:[InputSubviews] { get set }
}

//MARK: - Form Input With ViewModel

public protocol FormInputViewModelView: class {
    
    typealias DataType
    
    var viewModel: FormInputViewModel<DataType>? { get }
    
    func bindViewModel()
}

//Base UIView for any FormInputs which require a basic textfield, capture label, error label heirarchy
final class FormBaseTextInputView<T>: UIView {
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    //MARK: - Layout Configuration
    
    var inputViewLayout: InputViewLayout = InputViewLayout() {
        didSet {
            subviewOrder = inputViewLayout.subviewOrder
            stackView.spacing = CGFloat(inputViewLayout.subviewSpacing)
            stackView.axis = inputViewLayout.inputLayoutAxis
        }
    }
    
    //TODO: review access of these
    
    var subviewOrder = [InputSubviews.TextField, InputSubviews.ErrorLabel, InputSubviews.CaptionLabel]
    
    //MARK: - Subviews
    
    lazy var stackView: UIStackView = { [unowned self] in
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.spacing = 2.0
        stackView.distribution = .Fill
        self.addSubview(stackView)
        return stackView
    }()
    
    lazy var textField: UITextField = { [unowned self] in
        let textField = UITextField()
        return textField
    }()
    
    lazy var captionLabel: UILabel = { [unowned self] in
        let captionLabel = UILabel()
        captionLabel.numberOfLines = 0
        captionLabel.lineBreakMode = .ByWordWrapping
        return captionLabel
    }()
    
    lazy  var errorLabel: UILabel = { [unowned self] in
        let errorLabel = UILabel()
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = .ByWordWrapping
        return errorLabel
    }()
    
    //MARK: - Init
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    //MARK: - Layout
    
    override func updateConstraints() {
        super.updateConstraints()
        addSubviewConstraints()
        addSubviews()
    }
    
    override func intrinsicContentSize() -> CGSize {
        return stackView.intrinsicContentSize()
    }
    
    //MARK: - Add Subviews
    
    private var didAddSubviewConstriants = false
    
    private func addSubviewConstraints() {
        
        guard didAddSubviewConstriants == false else { return }
        
        didAddSubviewConstriants = true
        
        //layout subviews
        UIView.createConstraints(visualFormatting: [
            "H:|-(0)-[stackView]-(0)-|",
            "V:|-(0)-[stackView]-(0)-|",
            ],
            views: [
                "stackView": stackView,
            ])
        
        //give the textfield height priority when a view height is defined
        let constaint = textField.heightAnchor.constraintGreaterThanOrEqualToConstant(0)
        constaint.priority = 999
        constaint.active = true
        
        invalidateIntrinsicContentSize()
    }
    
    private var didAddSubviews = false
    
    private func addSubviews() {
        
        guard didAddSubviews == false else { return }
        
        didAddSubviews = true
        
        self.subviewOrder.forEach {
            
            switch $0 {
            case .TextField:
                self.stackView.addArrangedSubview(self.textField)
            case .ErrorLabel:
                self.stackView.addArrangedSubview(self.errorLabel)
            case .CaptionLabel:
                self.stackView.addArrangedSubview(self.captionLabel)
            }
        }

        invalidateIntrinsicContentSize()
    }
    
    func bindViewModel(viewModel: FormInputViewModel<T>) {
        
        viewModel.displayValueObservable.observe { self.textField.text = $0 }
        viewModel.placeholderObservable.observe { self.textField.attributedPlaceholder = $0 }
        
        viewModel.captionObservable.observe {
            self.captionLabel.hidden = $0.string.isEmpty
            self.captionLabel.attributedText = $0
        }
        
        viewModel.errorTextObservable.observe {
            self.errorLabel.hidden = ($0?.string.isEmpty) ?? true
            self.errorLabel.attributedText = $0
        }
        
        viewModel.returnKeyTypeObservable.observe { self.textField.returnKeyType = $0 }
        viewModel.secureTextEntryObservable.observe { self.textField.secureTextEntry = $0 }
        viewModel.keyboardTypeObservable.observe { self.textField.keyboardType = $0 }
        viewModel.autocorrectionTypeObservable.observe { self.textField.autocorrectionType = $0 }
        viewModel.enabledObservable.observe { self.textField.enabled = $0 }
        
        viewModel.focusedObservable.observe {
            if ($0 == true) {
                self.textField.becomeFirstResponder()
            }
        }
        
        self.inputViewLayout = viewModel.inputViewLayout
        
        //layout
        
        viewModel.inputViewLayoutObservable.observeNew {
            self.inputViewLayout = $0
            
            //teardown and reflow entire layour
            
            //TODO: diff order
            
            self.didAddSubviews = false

            while let arrangedSubView = self.stackView.arrangedSubviews.last {
                arrangedSubView.removeFromSuperview()
            }
            
            self.addSubviews()
        }
    }
}
