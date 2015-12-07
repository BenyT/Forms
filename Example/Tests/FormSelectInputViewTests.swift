//
//  FormSelectInputViewTests.swift
//  Forms
//
//  Created by mrandall on 12/7/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
@testable import Forms

class FormSelectInputViewTests: XCTestCase {
    
    lazy var viewModel: FormSelectInputViewModel<String> = {
        let vm = FormSelectInputViewModel(options: ["value1", "value2"], value: "value1")
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
    
    func test_displayValue() {
        
        let vm = viewModel
        
        let view = FormSelectInputView(withViewModel: vm)
        XCTAssertEqual(view.textField.text, "value1", "value was set on view")
        
        vm.value = "value2"
        XCTAssertEqual(view.textField.text, "value2", "value was updated on view")
    }
    
    func test_displayValue_displayValueMap() {
        
        let vm = viewModel
        
        let view = FormSelectInputView(withViewModel: vm)
        XCTAssertEqual(view.textField.text, "value1", "value was set on view")
        
        vm.displayValueMap = { (value) -> String in
            return "option \(value)"
        }
        
        XCTAssertEqual(view.textField.text, "option value1", "value was set on view")
        
        vm.value = "value2"
        XCTAssertEqual(view.textField.text, "option value2", "value was updated on view")
    }
}
