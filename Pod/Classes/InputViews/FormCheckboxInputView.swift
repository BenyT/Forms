//
//  FormCheckboxInputView.swift
//
//  Created by mrandall on 11/30/15.
//  Copyright © 2015 mrandall. All rights reserved.
//

import UIKit

private enum InputSelector: Selector {
    case CheckBoxButtonWastTapped = "checkBoxButtonWastTapped:"
}

@IBDesignable
public class FormCheckboxInputView: UIView, FormInputView, FormInputViewModelView {

    //MARK: - FormInputViewModelView
    
    public var viewModel: FormInputViewModel<Bool>? {
        didSet {
            bindViewModel()
        }
    }
    
    //MARK: - Subviews
    
    lazy public var checkBoxButton: UIButton = { [unowned self] in
        let checkBoxButton = UIButton()
        checkBoxButton.addTarget(self, action: InputSelector.CheckBoxButtonWastTapped.rawValue, forControlEvents: .TouchUpInside)
        self.addSubview(checkBoxButton)
        return checkBoxButton
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
    
    convenience public init(withViewModel viewModel: FormInputViewModel<Bool>) {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.viewModel = viewModel
        commonInit()
        bindViewModel()
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
        updateConstraints()
    }
    
    func commonInit() {
    }
    
    //MARK: - Layout
    
    override public func updateConstraints() {
        super.updateConstraints()
        
        //remove constaints added manaully
        layoutConstraints.forEach { $0.active = false }
        
        //layout subviews
        layoutConstraints = self.createConstraints(visualFormatting: [
            "H:|-(0)-[checkBoxButton(>=0@250)]-(10)-[captionLabel(>=0@750)]-(0)-|",
            "H:|-(0)-[errorLabel]-(0)-|",
            "V:|-(0)-[checkBoxButton]-(>=0)-[errorLabel]-(0)-|",
            "V:|-(0)-[captionLabel]-(>=0)-[errorLabel]-(0)-|",
            ],
            views: [
                "checkBoxButton": checkBoxButton,
                "captionLabel": captionLabel,
                "errorLabel": errorLabel,
            ])
        
        checkBoxButton.widthAnchor.constraintEqualToAnchor(checkBoxButton.heightAnchor, multiplier: 1.0).active = true
        captionLabel.heightAnchor.constraintEqualToAnchor(checkBoxButton.heightAnchor, multiplier: 1.0).active = true
    }
    
    //MARK: - FormInputViewModelView
    
    //bind to viewModel
    public func bindViewModel() {
        
        guard let viewModel = self.viewModel else {
            return
        }
                
        viewModel.valueObservable.observe { self.checkBoxButton.selected = $0 }
        viewModel.captionObservable.observe { self.captionLabel.text = $0 }
        viewModel.errorTextObservable.observe { self.errorLabel.text = $0 }
    }
    
    //MARK: - Actions
    
    func checkBoxButtonWastTapped(sender: AnyObject) {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        viewModel.value = !viewModel.value!
    }
}
