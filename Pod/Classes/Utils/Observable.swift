//
//  Observable.swift
//  Pods
//
//  The MIT License (MIT)
//
//  Created by mrandall on 2/13/16.
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

import Foundation

public class Observable<ValueType: Any> {
    
    private var _value: ValueType?
    
    private var value: ValueType? {
        get {
            return _value
        }
        set {
            _value = newValue
            if let value = newValue {
                observers.forEach { $0.next(value) }
            }
        }
    }
    
    var next: ValueType? {
        return value
    }
    
    private var observers = [Subscriber<ValueType>]()
    
    /// init with value
    ///
    /// - Parameter value: ValueType? value can be Any
    public init(_ value: ValueType?) {
        self.value = value
    }
    
    /// observer new value changes
    ///
    /// - Parameter observer: AnyObject
    /// - Parameter next: ValueType? -> Void
    public func observeNew(next: ValueType -> Void) {
        observers.append( Subscriber(next: next) )
    }
    
    /// observer new value changes
    /// and return current value
    ///
    /// - Parameter observer: AnyObject
    /// - Parameter next: ValueType? -> Void
    public func observe(next: ValueType -> Void) {
        observeNew(next)
        if let value = value {
            next(value)
        }
    }
}

public final class Subject<ValueType: Any>: Observable<ValueType> {
    
    override init(_ value: ValueType? = nil) {
        super.init(value)
    }
    
    func asObservable() -> Observable<ValueType> {
        return self as Observable<ValueType>
    }
    
    public func next(value: ValueType?) {
        self.value = value
    }
}

public struct Subscriber<ValueType> {
    
    //public weak var observer: AnyObject?
    private var next: ValueType -> Void
    
    public init(next: ValueType -> Void) {
        //self.observer = observer
        self.next = next
    }
}