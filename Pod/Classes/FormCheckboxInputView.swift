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
class FormCheckboxInputView: UIView, FormInputView {

    //MARK: - ViewModel
    
    var viewModel: FormInputViewModel<Bool>? {
        didSet {
            bindViewModel()
        }
    }
    
    //MARK: - Subviews
    
    lazy var checkBoxButton: UIButton = { [unowned self] in
        let checkBoxButton = UIButton()
        checkBoxButton.addTarget(self, action: InputSelector.CheckBoxButtonWastTapped.rawValue, forControlEvents: .TouchUpInside)
        self.addSubview(checkBoxButton)
        return checkBoxButton
    }()
    
    //next input in form
    @IBOutlet var nextInput: FormInputView?
    
    //manually added layout constraints
    private var layoutConstraints = [NSLayoutConstraint]()
    
    //MARK: - Init
    
    convenience init(withViewModel viewModel: FormInputViewModel<Bool>) {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.viewModel = viewModel
        commonInit()
        bindViewModel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        commonInit()
        updateConstraints()
    }
    
    func commonInit() {
        themeView()
    }
    
    //MARK: - Layout
    
    override func updateConstraints() {
        super.updateConstraints()
        
        //remove constaints added manaully
        layoutConstraints.forEach { $0.active = false }
        
        //layout subviews
        layoutConstraints = self.createConstraints(visualFormatting: [
            "H:|-(0)-[checkBoxButton]-(0)-|",
            "V:|-(0)-[checkBoxButton]-(0)-|",
            ],
            views: [
                "checkBoxButton": checkBoxButton,
            ])
    }
    
    //MARK: - Bind ViewModel
    
    //bind to viewModel
    func bindViewModel() {
        checkBoxButton.selected = viewModel?.value ?? false
    }

    //MARK: - Theme
    
    //theme view and subviews
    func themeView() {
        backgroundColor = UIColor.clearColor()
    }
    
    //MARK: - Actions
    
    func checkBoxButtonWastTapped(sender: AnyObject) {
        
        guard
            let viewModel = self.viewModel,
            let value = viewModel.value
        else {
            return
        }
        
        viewModel.value = !value
        checkBoxButton.selected = !value
    }
}
