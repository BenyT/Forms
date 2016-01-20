//
//  FormInputViewModelTests.swift
//  Forms
//
//  Created by mrandall on 12/7/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
@testable import Forms

class FormInputViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_init() {
        let vm = FormInputViewModel(identifier: "test", value: "value")
        XCTAssertEqual(vm.value, "value", "value set")
        XCTAssertEqual(vm.valid, true, "valid default value is true")
        XCTAssertEqual(vm.errorText, nil, "errorText default value is nil")
        XCTAssertEqual(vm.caption, "", "caption default value is empty string")
        XCTAssertEqual(vm.enabled, true, "enabled default value is true")
        XCTAssertEqual(vm.returnKeyType, UIReturnKeyType.Default, "returnKeyType default value is .Default")
        XCTAssertNil(vm.nextInputsViewModel, "nextInputsViewModel default value is nil")
        XCTAssertEqual(vm.autocorrectionType, UITextAutocorrectionType.Default, "autocorrectionType default value is .Default")
        XCTAssertEqual(vm.secureTextEntry, false, "secureTextEntry is false by default")
        XCTAssertEqual(vm.keyboardType, UIKeyboardType.Default, "keyboardType default value is .Default")
    }
    
    func test_displayValueMap() {
        
        let vm = FormInputViewModel(identifier: "test", value: "value")
        vm.displayValueMap = { (value) -> String in
            return "displayValue for \(value)"
        }
        vm.value = "value2"
        XCTAssertEqual(vm.displayValue, "displayValue for value2")
        
        //out of order
        let vm2 = FormInputViewModel(identifier: "test", value: "value")
        vm2.value = "value2"
        vm2.displayValueMap = { (value) -> String in
            return "displayValue for \(value)"
        }
        XCTAssertEqual(vm2.displayValue, "displayValue for value2")
    }
    
    func test_displayValue() {
        let vm = FormInputViewModel(identifier: "test", value: "value")
        XCTAssertEqual(vm.displayValue, "value", "displayValue derived from value if string")
    }
    
    func test_validation() {
        
        let vm = FormInputViewModel(identifier: "test", value: "value")
        XCTAssertEqual(vm.valid, true, "vm is validate by default")
        vm.validationRules = [
            FormInputValidationRule(failureText: "failed") { (value) -> Bool in
                return false
            }
        ]
        
        //TODO: validationRules didSet observer currently relies on GCD delay
        let expectation = expectationWithDescription("test_validation")
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            XCTAssertEqual(vm.valid, false, "vm is invalid after rules set")
            XCTAssertEqual(vm.errorText, nil, "errorText is nil")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    func test_valid() {
        
        let vm = FormInputViewModel(identifier: "test", value: "value")
        
        XCTAssertEqual(vm.valid, true, "valid default value is true")
        
        vm.validationRules = [
            FormInputValidationRule(failureText: "failed") { (value) -> Bool in
                value == "value2"
            }
        ]
        
        //TODO: validationRules didSet observer currently relies on GCD delay
        let expectation = expectationWithDescription("test_validation")
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            XCTAssertEqual(vm.valid, false, "valid is false after failing rules fail")
    
            vm.value = "value2"
            XCTAssertEqual(vm.valid, true, "errorText is set")
            
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    func test_inputValueToValidate() {
        
        let vm = FormInputViewModel(identifier: "test", value: "value")
        XCTAssertEqual(vm.inputValueToValidate, "value", "inputValueToValidate is equal to value value")
    }
    
    func test_displayValidationErrorsOnValueChange() {
        
        let vm = FormInputViewModel(identifier: "test", value: "value")
        vm.validationRules = [
            FormInputValidationRule(failureText: "failed") { (value) -> Bool in
                false
            }
        ]
        
        //TODO: validationRules didSet observer currently relies on GCD delay
        let expectation = expectationWithDescription("test_validation")
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            XCTAssertEqual(vm.displayValidationErrorsOnValueChange, false, "displayValidationErrorsOnValueChange default is false")
            vm.displayValidationErrorsOnValueChange = true
            XCTAssertEqual(vm.errorText, "failed", "errorText is set")
            
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    func test_validateUsingDisplayValidationErrorsOnValueChangeValue() {
        
        let vm = FormInputViewModel(identifier: "test", value: "value")
        vm.validationRules = [
            FormInputValidationRule(failureText: "failed") { (value) -> Bool in
                false
            }
        ]
        
        //TODO: validationRules didSet observer currently relies on GCD delay
        let expectation = expectationWithDescription("test_validation")
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            vm.validateUsingDisplayValidationErrorsOnValueChangeValue()
            XCTAssertEqual(vm.errorText, nil, "errorText is set")
            
            vm.displayValidationErrorsOnValueChange = true
            vm.validateUsingDisplayValidationErrorsOnValueChangeValue()
            XCTAssertEqual(vm.errorText, "failed", "errorText is set")
            
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
}
