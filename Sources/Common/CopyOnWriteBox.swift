//
//  CopyOnWriteBox.swift
//
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation

public class CopyOnWriteRef<T> {
    public var value: T
    
    public init(_ value: T) {
        self.value = value
    }
}

public struct CopyOnWriteBox<T> {
    private var ref: CopyOnWriteRef<T>
    
    public var value: T {
        get {
            return self.ref.value
        }
        set {
            if !isKnownUniquelyReferenced(&self.ref) {
                ref = CopyOnWriteRef(newValue)
                return
            }
            ref.value = newValue
        }
    }
    
    public init(_ val: T) {
        self.ref = CopyOnWriteRef(val)
    }
}
