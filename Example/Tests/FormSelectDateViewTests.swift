//
//  FormSelectDateViewTests.swift
//  Forms
//
//  Created by mrandall on 12/7/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
import Forms

class FormSelectDateViewTests: XCTestCase {
    
    lazy var viewModel: FormInputViewModel<NSDate> = {
        let vm = FormInputViewModel(identifier: "test", value: NSDate(timeIntervalSince1970: 0))
        vm.placeholder = "placeholder"
        vm.caption = "caption"
        return vm
    }()
    
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_displayValue_displayValueMap() {
        
        let vm = viewModel
        
        let view = FormSelectDateInputView(withViewModel: vm)
        XCTAssertEqual(view.textField.text, "", "value was set on view")
        
        vm.displayValueMap = { (value) -> String in
            return self.dateFormatter.stringFromDate(value)
        }
        
        XCTAssertEqual(view.textField.text, "Jan 01, 1970", "value was set on view")
        
        vm.value = NSDate(timeIntervalSince1970: 60 * 60 * 24)
        XCTAssertEqual(view.textField.text, "Jan 02, 1970", "value was updated on view")
    }
}
