//
//  Observable.swift
//  Pods
//
//  Created by mrandall on 2/13/16.
//
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