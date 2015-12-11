//
//  FormSelectInputView.swift
//  Pods
//
//  Created by mrandall on 12/5/15.
//
//

import UIKit

@IBDesignable
public class FormSelectInputView<T>: UIView, FormInputView, FormInputViewModelView, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    //MARK: - FormInputViewModelView
    
    public var viewModel: FormInputViewModel<T>? {
        didSet {
            bindViewModel()
        }
    }
    
    //MARK: - FormBaseTextInputView
    
    private lazy var formBaseTextInputView: FormBaseTextInputView<T> = { [unowned self] in
        let ui = FormBaseTextInputView<T>()
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
    
    public init(withViewModel viewModel: FormSelectInputViewModel<T>) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.viewModel = viewModel
        commonInit()
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
    
    public func commonInit() {
        bindViewModel()
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
    
    public func bindViewModel() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        formBaseTextInputView.bindViewModel(viewModel)
        
        viewModel.focusedObservable.observe {
            if ($0 == true) {
                self.becomeFirstResponder()
            } else {
                self.resignFirstResponder()
            }
        }
    }

    //MARK: - UIResponder
    
    override public func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    override public func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    //MARK: - UITextFieldDelegate
    
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
    
    //MARK: - UIPickerViewDataSource
        
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        guard let viewModel = viewModel as? FormSelectInputViewModel else {
            return 0
        }
        
        let placeholderOffset = (viewModel.pickerPlaceholder != nil) ? 1 : 0
        
        return viewModel.options.count + placeholderOffset
    }
    
    //MARK: - UIPickerViewDelegate
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard let viewModel = viewModel as? FormSelectInputViewModel else {
            return ""
        }
        
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
        
        guard let viewModel = viewModel as? FormSelectInputViewModel else {
            return
        }
        
        if row == 0 && viewModel.pickerPlaceholder != nil {
            viewModel.value = nil
            return
        }
        
        let placeholderOffset = (viewModel.pickerPlaceholder != nil) ? 1 : 0

        viewModel.value = viewModel.options[row - placeholderOffset]
    }
}
