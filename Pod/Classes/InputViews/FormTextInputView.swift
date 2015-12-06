//
//  FormTextInputView.swift
//
//  Created by mrandall on 10/27/15.
//  Copyright © 2015 mrandall. All rights reserved.
//

import UIKit

public enum FormInputViewNotification: String {
    case GoButtonTapped
}

public protocol FormInputView: class {
    
    func becomeFirstResponder() -> Bool
}

public protocol FormInputViewModelView: class {
    
    typealias DataType
    
    var viewModel: FormInputViewModel<DataType>? { get }
    
    func bindViewModel()
}

@IBDesignable
public class FormTextInputView: UIView, FormInputView, FormInputViewModelView, UITextFieldDelegate {
    
    //MARK: - FormInputViewModelView
    
    public var viewModel: FormInputViewModel<String>? {
        didSet {
            bindViewModel()
        }
    }
    
    //MARK: - FormBaseTextInputView
    
    private lazy var formBaseTextInputView: FormBaseTextInputView<String> = { [unowned self] in
        let ui = FormBaseTextInputView<String>()
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

    //MARK: - Init
    
    convenience public init(withViewModel viewModel: FormInputViewModel<String>) {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.viewModel = viewModel
        commonInit()
    }

    public func commonInit() {
        bindViewModel()
        textField.delegate = self
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
        
        formBaseTextInputView.bindViewModel(viewModel)
        
        viewModel.isFirstResponderObservable.observe {
            if ($0 == true) {
                self.becomeFirstResponder()
            }
        }
    }
    
    override public func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }

    //MARK: - UITextFieldDelegate
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if var nextInput = self.viewModel?.nextInputsViewModel {
            viewModel?.isFirstResponder = false
            nextInput.isFirstResponder = true
        } else {
            textField.resignFirstResponder()
        }
        
        if textField.returnKeyType == .Go {
            NSNotificationCenter.defaultCenter().postNotificationName(FormInputViewNotification.GoButtonTapped.rawValue, object: self)
        }
        
        return true
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        viewModel?.value = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        return false
    }
    
    public func textFieldShouldClear(textField: UITextField) -> Bool {
        viewModel?.value = ""
        return true
    }
}


