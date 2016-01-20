//
//  FormCheckboxInputViewTests.swift
//  Forms
//
//  Created by mrandall on 12/7/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
@testable import Forms

class FormCheckboxInputViewTests: XCTestCase {
    
    lazy var viewModel: FormInputViewModel<Bool> = {
        let vm = FormInputViewModel(identifier: "test", value: false)
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
    
    func test_buttonSelected() {
        
        let vm = viewModel
        
        let view = FormCheckboxInputView(withViewModel: vm)
        XCTAssertEqual(view.button.selected, false, "checkBoxButton.selected is initially false")
        
        vm.value = true
        XCTAssertEqual(view.button.selected, true, "checkBoxButton.selected was updated")
    }
}
