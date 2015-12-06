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

@objc
public protocol FormInputView: class {
    
    var nextInput: FormInputView? { get set }
    
    func becomeFirstResponder() -> Bool
    
    func themeView()
}

public protocol FormInputViewModelView: class {
    
    typealias DataType
    
    var viewModel: FormInputViewModel<DataType>? { get }
    
    func bindViewModel()
}

//Base UIView for any FormInputs which require a basic textfield, capture label, error label heirarchy
public class FormBaseTextInputView: UIView {
    
    lazy public var textField: UITextField = { [unowned self] in
        let textField = UITextField()
        self.addSubview(textField)
        return textField
    }()
    
    lazy public var captionLabel: UILabel = { [unowned self] in
        let captionLabel = UILabel()
        captionLabel.lineBreakMode = .ByWordWrapping
        self.addSubview(captionLabel)
        return captionLabel
    }()
    
    lazy public var errorLabel: UILabel = { [unowned self] in
        let errorLabel = UILabel()
        errorLabel.lineBreakMode = .ByWordWrapping
        self.addSubview(errorLabel)
        return errorLabel
    }()
    
    //manually added layout constraints
    private var layoutConstraints = [NSLayoutConstraint]()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public func prepareForInterfaceBuilder() {
        commonInit()
        updateConstraints()
    }
    
    public func commonInit() {
        themeView()
    }
    
    //MARK: - Layout
    
    override public func updateConstraints() {
        super.updateConstraints()
        
        //remove constaints added manaully
        layoutConstraints.forEach { $0.active = false }
        
        //vertical margins
        let captionLabelTop = 0.0
        let errorLabelTop = 0.0
        
        //layout subviews
        layoutConstraints = createConstraints(visualFormatting: [
            "H:|-(0)-[textfield]-(0)-|",
            "H:|-(0)-[captionLabel]-(0)-|",
            "H:|-(0)-[errorLabel]-(0)-|",
            "V:|-(0)-[textfield(>=30)]-(\(errorLabelTop))-[errorLabel(>=0)]-(\(captionLabelTop))-[captionLabel(>=0)]-(0)-|"
            ],
            views: [
                "textfield": textField,
                "captionLabel": captionLabel,
                "errorLabel": errorLabel,
            ])
    }
    
    //MARK: - Theme
    
    //theme view and subviews
    public func themeView() {
        backgroundColor = UIColor.clearColor()
        captionLabel.font = UIFont.systemFontOfSize(11.0)
        captionLabel.textColor = UIColor.lightGrayColor()
        errorLabel.font = UIFont.systemFontOfSize(11.0)
        errorLabel.textColor = UIColor.redColor()
    }
}

@IBDesignable
public class FormTextInputView: FormBaseTextInputView, FormInputView, FormInputViewModelView, UITextFieldDelegate {
    
    public var viewModel: FormInputViewModel<String>? {
        didSet {
            bindViewModel()
        }
    }
    
    //next input in form
    @IBOutlet public var nextInput: FormInputView? {
        didSet {
            viewModel?.returnKeyType = .Next
            textField.returnKeyType = .Next
        }
    }

    //MARK: - Init
    
    convenience public init(withViewModel viewModel: FormInputViewModel<String>) {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.viewModel = viewModel
        commonInit()
    }

    override public func commonInit() {
        super.commonInit()
        bindViewModel()
        textField.delegate = self
    }
    
    //MARK: - FormInputViewModelView
    
    //bind to viewModel
    public func bindViewModel() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        textField.placeholder = viewModel.placeholder
        textField.text = viewModel.value
        textField.returnKeyType = viewModel.returnKeyType
        captionLabel.text = viewModel.caption
        errorLabel.text = viewModel.errorText ?? ""
    }
    
    override public func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }

    //MARK: - UITextFieldDelegate
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        bindViewModel()
        return true
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if let nextInput = self.nextInput {
            nextInput.becomeFirstResponder()
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
        textField.text = viewModel?.value
        return false
    }
    
    public func textFieldShouldClear(textField: UITextField) -> Bool {
        viewModel?.value = ""
        return true
    }
}


