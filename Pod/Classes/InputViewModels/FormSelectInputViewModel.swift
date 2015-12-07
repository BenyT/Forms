//
//  FormSelectInputViewModel.swift
//  Pods
//
//  Created by mrandall on 12/6/15.
//
//

import UIKit

public class FormSelectInputViewModel<T>: FormInputViewModel<T> {

    public var options: [T]
    
    public var pickerPlaceholder: String?
    
    //MARK: - Init
    
    // Init
    //
    // - Parameter value: T
    public init(options: [T], value: T?) {
        self.options = options
        super.init(value: value)
    }
    
}
