//
//  FormSelectInputViewModel.swift
//
//  The MIT License (MIT)
//
//  Created by mrandall on 12/06/15.
//  Copyright © 2015 mrandall. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
import UIKit
import Bond

public class FormSelectInputViewModel<T>: FormInputViewModel<T> {

    public var optionsObservable: Observable<[T]>
    public var options: [T] {
        didSet {
            optionsObservable.next(options)
        }
    }
    
    public var pickerPlaceholder: String?
    
    //MARK: - Init
    
    // Init
    //
    // - Parameter value: T
    public init(identifier: String, options: [T], value: T?) {
        self.options = options
        self.optionsObservable = Observable(options)
        super.init(identifier: identifier, value: value)
    }
    
}
