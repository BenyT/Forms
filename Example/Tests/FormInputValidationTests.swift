//
//  FormInputValidationTests.swift
//  Forms
//
//  Created by mrandall on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Forms

class FormInputValidationTests: XCTestCase {
    
    lazy var viewModelWithNotNilValidation: FormInputViewModel<String> = {
        let vm = FormInputViewModel<String>(identifier: "test", value: nil)
        vm.placeholder = "placeholder"
        vm.caption = "caption"
        
        vm.validationRules = [
            FormInputValidationRule(failureText: "Cant be nil") { inputValue -> Bool in
                return inputValue != nil
            }
        ]
        
        return vm
    }()
    
    lazy var viewModelWithNotNilValidationWithNoMessage: FormInputViewModel<String> = {
        let vm = FormInputViewModel<String>(identifier: "test", value: nil)
        vm.placeholder = "placeholder"
        vm.caption = "caption"
        
        vm.validationRules = [
            FormInputValidationRule(failureText: "") { inputValue -> Bool in
                return inputValue != nil
            }
        ]
        
        return vm
    }()

    func testValidation() {
        
        let vm = viewModelWithNotNilValidation
        vm.validate()
        XCTAssertEqual(vm.errorText, "Cant be nil", "Error text was set")
        XCTAssertFalse(vm.valid, "ViewModel is not valid")
    }
    
    func testValidationRuleWithOutMessage() {
        
        let vm = viewModelWithNotNilValidationWithNoMessage
        vm.validate()
        XCTAssertEqual(vm.errorText, "", "Error text was set")
        XCTAssertFalse(vm.valid, "ViewModel is not valid")

    }


}
