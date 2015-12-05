//
//  FormDateInputViewModel.swift
//
//  Created by mrandall on 11/30/15.
//  Copyright © 2015 mrandall. All rights reserved.
//

import Foundation

class FormDateInputViewModel: FormInputViewModel<NSDate> {
    
    static var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    
    override var value: NSDate? {
        didSet {
            if let value = self.value {
                displayValue = FormDateInputViewModel.dateFormatter.stringFromDate(value)
            }
        }
    }
    
    //MARK: - Init
    
    // Init
    //
    // - Parameter value: NSDate
    override init(value: NSDate, caption: String = "") {
        super.init(value: value, caption: caption)
    }
}