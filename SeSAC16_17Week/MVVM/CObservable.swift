//
//  CObservable.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/25.
//

import Foundation

/*
 Observable
 */

class CObservable<T> {
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
    
}
