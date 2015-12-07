//
//  FormTextInputViewTests.swift
//  Forms
//
//  Created by mrandall on 12/6/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
@testable import Forms

class FormTextInputViewTests: XCTestCase {
    
    lazy var viewModel: FormInputViewModel<String> = {
        let vm = FormInputViewModel(value: "value")
        vm.placeholder = "placeholder"
        vm.caption = "caption"
        return vm
    }()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_value() {
        
        let vm = viewModel
        
        let view = FormTextInputView(withViewModel: vm)
        XCTAssertEqual(view.textField.text, "value", "value was set on view")
        
        vm.value = "value2"
        XCTAssertEqual(view.textField.text, "value2", "value was updated on view")
    }
    
    func test_placeholder() {
        
        let vm = viewModel
        
        let view = FormTextInputView(withViewModel: vm)
        XCTAssertEqual(view.textField.placeholder, "placeholder", "placholder was set on view")
        
        vm.placeholder = "placeholder2"
        XCTAssertEqual(view.textField.placeholder, "placeholder2", "placeholder was updated on view")
    }
    
    func test_caption() {
        
        let vm = viewModel
        
        let view = FormTextInputView(withViewModel: vm)
        XCTAssertEqual(view.captionLabel.text, "caption", "caption was set on view")
        
        vm.caption = "caption2"
        XCTAssertEqual(view.captionLabel.text, "caption2", "caption was updated on view")
    }
    
    func test_error() {
        
        let vm = viewModel
        
        let view = FormTextInputView(withViewModel: vm)
        XCTAssertEqual(view.errorLabel.text, "", "error was set on view")
        
        vm.errorText = "error2"
        XCTAssertEqual(view.errorLabel.text, "error2", "error was updated on view")
    }
    
    func test_enabled() {
        
        let vm = viewModel
        
        let view = FormTextInputView(withViewModel: vm)
        XCTAssertEqual(view.textField.enabled, true, "textfield is enabled by default")
        
        vm.enabled = false
        XCTAssertEqual(view.textField.enabled, false, "enabled was updated on view")
    }
    
    func test_returnKeyType() {
        
        let vm = viewModel
        
        let view = FormTextInputView(withViewModel: vm)
        
        XCTAssertEqual(view.textField.returnKeyType, UIReturnKeyType.Default, "textfield returnKeyType is .Default by default")
        
        vm.returnKeyType = UIReturnKeyType.Go
        XCTAssertEqual(view.textField.returnKeyType, UIReturnKeyType.Go, "textfield returnKeyType was updated")
    }
    
    func test_secureTextEntry() {
        
        let vm = viewModel
        
        let view = FormTextInputView(withViewModel: vm)
        
        XCTAssertEqual(view.textField.secureTextEntry, false, "textfield secureTextEntry is false by default")
        
        vm.secureTextEntry = true
        XCTAssertEqual(view.textField.secureTextEntry, true, "textfield secureTextEntry was updated")
    }
    
    func test_autocorrectionType() {
        
        let vm = viewModel
        
        let view = FormTextInputView(withViewModel: vm)
        
        XCTAssertEqual(view.textField.autocorrectionType, UITextAutocorrectionType.Default, "textfield autocorrectionType is .Default by default")
        
        vm.autocorrectionType = UITextAutocorrectionType.No
        XCTAssertEqual(view.textField.autocorrectionType, UITextAutocorrectionType.No, "textfield autocorrectionType was updated")
    }
    
    func test_keyboardType() {
        
        let vm = viewModel
        
        let view = FormTextInputView(withViewModel: vm)
        
        XCTAssertEqual(view.textField.keyboardType, UIKeyboardType.Default, "textfield keyboardType is .Default by default")
        
        vm.keyboardType = UIKeyboardType.NumberPad
        XCTAssertEqual(view.textField.keyboardType, UIKeyboardType.NumberPad, "textfield keyboardType was updated")
    }
    
}
