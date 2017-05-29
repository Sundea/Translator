//
//  Queue.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/23/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

public struct Queue<T>: CustomStringConvertible {
    fileprivate(set) var array = [T]()
    
    init(_ array: [T]) {
        self.array = array
    }
    
    init() { }
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    public var front: T? {
        return array.first
    }
    
    public var description: String {
        return array.reduce("") {result, next in "\(result) \(next)" }
    }
}
