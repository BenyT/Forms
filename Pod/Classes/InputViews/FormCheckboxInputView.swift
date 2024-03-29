//
//  FormCheckboxInputView.swift
//
//  The MIT License (MIT)
//
//  Created by mrandall on 11/30/15.
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

private enum InputSelector: Selector {
    case buttonWastTapped = "buttonWastTapped:"
}

//@IBDesignable
public class FormCheckboxInputView: UIView, ButtonFormIputView {
    
    override public class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    //MARK: - FormInputView
    
    public var identifier: String
    
    //MARK: - FormInputViewModelView
    
    public var viewModel: FormInputViewModel<Bool>? {
        didSet {
            bindViewModel()
        }
    }
    
    //MARK: - Layout Configuration
    
    public var inputSpacing = 0.1
    
    //MARK: - FormBaseTextInputView
    
    lazy var stackView: UIStackView = { [unowned self] in
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.spacing = CGFloat(self.inputSpacing)
        stackView.distribution = .Fill
        self.addSubview(stackView)
        return stackView
        }()
    
    lazy var checkBoxCaptionStackView: UIStackView = { [unowned self] in
        let stackView = UIStackView()
        stackView.axis = .Horizontal
        stackView.spacing = CGFloat(self.inputSpacing)
        stackView.distribution = .Fill
        return stackView
        }()
    
    //MARK: - Subviews
    
    lazy public var button: UIButton = { [unowned self] in
        let button = UIButton()
        button.addTarget(self, action: InputSelector.buttonWastTapped.rawValue, forControlEvents: .TouchUpInside)
        return button
        }()
    
    lazy public var captionLabel: UILabel = { [unowned self] in
        let captionLabel = UILabel()
        captionLabel.lineBreakMode = .ByWordWrapping
        return captionLabel
        }()
    
    lazy public var errorLabel: UILabel = { [unowned self] in
        let errorLabel = UILabel()
        errorLabel.lineBreakMode = .ByWordWrapping
        return errorLabel
        }()
    
    //MARK: - Init
    
    public convenience init(withViewModel viewModel: FormInputViewModel<Bool>) {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        identifier = viewModel.identifier
        self.viewModel = viewModel
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
    
    override public func prepareForInterfaceBuilder() {
        commonInit()
        addSubviewConstraints()
        addSubviews()
    }
    
    func commonInit() {
        bindViewModel()
    }
    
    //MARK: - Layout
    
    override public func updateConstraints() {
        addSubviewConstraints()
        addSubviews()
        super.updateConstraints()
    }
    
    override public func intrinsicContentSize() -> CGSize {
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
        
        button.widthAnchor.constraintEqualToAnchor(button.heightAnchor, multiplier: 1.0).active = true
        
        invalidateIntrinsicContentSize()
        
    }
    
    private var didAddSubviews = false
    
    private func addSubviews() {
        
        guard didAddSubviews == false else { return }
        
        didAddSubviews = true
        
        checkBoxCaptionStackView.addArrangedSubview(self.button)
        checkBoxCaptionStackView.addArrangedSubview(self.captionLabel)
        
        stackView.addArrangedSubview(checkBoxCaptionStackView)
        stackView.addArrangedSubview(errorLabel)
        
        invalidateIntrinsicContentSize()
    }
    
    //MARK: - Actions
    
    func buttonWastTapped(sender: AnyObject) {
        guard let viewModel = self.viewModel else { return }
        viewModel.value = !viewModel.value!
    }
    
    //MARK: - FormInputViewModelView
    
    public func bindViewModel() {
        
        guard let viewModel = self.viewModel else { return }
        
        viewModel.valueObservable.observe { self.button.selected = $0 ?? false }
        viewModel.captionObservable.observe { self.captionLabel.attributedText = $0 }
        viewModel.hiddenObservable.observe { self.hidden = $0 }
        
        viewModel.errorTextObservable.observe {
            self.errorLabel.hidden = $0.string.isEmpty
            self.errorLabel.attributedText = $0
        }
        
        viewModel.inputViewLayoutObservable.observe {
            self.stackView.spacing = CGFloat($0.subviewSpacing)
            self.checkBoxCaptionStackView.spacing = CGFloat($0.subviewSpacing)
        }
    }
}


//MARK: - Equatable

func ==(lhs: FormCheckboxInputView, rhs: FormCheckboxInputView) -> Bool {
    return lhs.identifier == rhs.identifier
}


