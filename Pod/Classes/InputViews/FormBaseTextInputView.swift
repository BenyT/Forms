//
//  FormBaseTextInputView.swift
//  Pods
//
//  Created by mrandall on 12/5/15.
//
//

import UIKit

//Base UIView for any FormInputs which require a basic textfield, capture label, error label heirarchy
final class FormBaseTextInputView: UIView {
    
    lazy var textField: UITextField = { [unowned self] in
        let textField = UITextField()
        self.addSubview(textField)
        return textField
    }()
    
    lazy var captionLabel: UILabel = { [unowned self] in
        let captionLabel = UILabel()
        captionLabel.lineBreakMode = .ByWordWrapping
        self.addSubview(captionLabel)
        return captionLabel
    }()
    
    lazy  var errorLabel: UILabel = { [unowned self] in
        let errorLabel = UILabel()
        errorLabel.lineBreakMode = .ByWordWrapping
        self.addSubview(errorLabel)
        return errorLabel
    }()
    
    //manually added layout constraints
    private var layoutConstraints = [NSLayoutConstraint]()
    
    //MARK: - Layout
    
    override func updateConstraints() {
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
    
    func bindViewModel(viewModel: FormInputViewModel<String>) {
        
        viewModel.placeholderObservable.observe { self.textField.attributedPlaceholder = $0 }
        viewModel.captionObservable.observe { self.captionLabel.text = $0 }
        viewModel.errorTextObservable.observe { self.errorLabel.text = $0 }
        viewModel.returnKeyTypeObservable.observe { self.textField.returnKeyType = $0 }
        viewModel.secureTextEntryObservable.observe { self.textField.secureTextEntry = $0 }
        viewModel.keyboardTypeObservable.observe { self.textField.keyboardType = $0 }
        viewModel.autocorrectionTypeObservable.observe { self.textField.autocorrectionType = $0 }
        
        viewModel.isFirstResponderObservable.observe {
            if ($0 == true) {
                self.becomeFirstResponder()
            }
        }
    }
}
