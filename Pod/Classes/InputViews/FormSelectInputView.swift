//
//  FormSelectInputView.swift
//  Pods
//
//  Created by mrandall on 12/5/15.
//
//

import UIKit

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
        bindViewModel()
    }
    
    public func commonInit() {
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
        
        return viewModel.options.count
    }
    
    //MARK: - UIPickerViewDelegate
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard let viewModel = viewModel as? FormSelectInputViewModel else {
            return ""
        }
        
        if let map = viewModel.displayValueMap {
            return map(viewModel.options[row])
        } else {
            return viewModel.options[row] as? String ?? ""
        }
    }

    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard let viewModel = viewModel as? FormSelectInputViewModel else {
            return
        }
        
        viewModel.value = viewModel.options[row]
    }
}
