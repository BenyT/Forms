//
//  FormBaseTextInputView.swift
//  Pods
//
//  Created by mrandall on 12/5/15.
//
//

import UIKit

public enum InputSubviews {
    case TextField
    case CaptionLabel
    case ErrorLabel
}

public protocol FormInputView: class {
    
    func becomeFirstResponder() -> Bool
}

public protocol FormInputViewModelView: class {
    
    typealias DataType
    
    var viewModel: FormInputViewModel<DataType>? { get }
    
    func bindViewModel()
}

protocol FormBaseTextInputViewLayout {
    
    var inputLayoutAxis: UILayoutConstraintAxis { get set }
    
    var subviewSpacing: Double { get set }
    
    var subviewOrder:[InputSubviews] { get set }
}

//Base UIView for any FormInputs which require a basic textfield, capture label, error label heirarchy
final class FormBaseTextInputView<T>: UIView {
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    //MARK: - Layout Configuration
    
    //TODO support settings this directly
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
        stackView.distribution = .EqualSpacing
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
        
        guard didAddSubviewConstriants == false else {
            return
        }
        
        didAddSubviewConstriants = true
        
        //layout subviews
        createConstraints(visualFormatting: [
            "H:|-(0)-[stackView]-(0)-|",
            "V:|-(0)-[stackView]-(0)-|",
            ],
            views: [
                "stackView": stackView,
            ])
        
        invalidateIntrinsicContentSize()
    }
    
    private var didAddSubviews = false
    
    private func addSubviews() {
        
        guard didAddSubviews == false else {
            return
        }
        
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

        self.invalidateIntrinsicContentSize()

        invalidateIntrinsicContentSize()
    }
    
    func bindViewModel(viewModel: FormInputViewModel<T>) {
        
        viewModel.displayValueObservable.observe { self.textField.text = $0 }
        viewModel.placeholderObservable.observe { self.textField.attributedPlaceholder = $0 }
        viewModel.captionObservable.observe { self.captionLabel.attributedText = $0 }
        viewModel.errorTextObservable.observe { self.errorLabel.attributedText = $0 }
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
