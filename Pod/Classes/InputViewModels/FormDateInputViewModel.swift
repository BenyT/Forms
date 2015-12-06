//
//  FormDateInputViewModel.swift
//
//  Created by mrandall on 11/30/15.
//  Copyright © 2015 mrandall. All rights reserved.
//

import Foundation

public class FormDateInputViewModel: FormInputViewModel<NSDate> {
    
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    
    override public var value: NSDate? {
        didSet {
            super.value = value
            if let value = value {
                displayValue = dateFormatter.stringFromDate(value)
            } else {
                displayValue = ""
            }
        }
    }
    
    //MARK: - Init
    
    // Init
    //
    // - Parameter value: NSDate
    override public init(value: NSDate, caption: String = "") {
        super.init(value: value, caption: caption)
    }
}