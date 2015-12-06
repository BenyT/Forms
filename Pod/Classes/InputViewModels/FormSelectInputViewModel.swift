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
    
    //MARK: - Init
    
    // Init
    //
    // - Parameter value: T
    public init(options: [T], value: T, caption: String = "") {
        self.options = options
        super.init(value: value, caption: caption)
    }
    
}
