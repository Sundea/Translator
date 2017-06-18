//
//  Label.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/29/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class Label: ReversePolishElement, CustomStringConvertible, Equatable {
    
    /// Mark index
    let index: Int
    
    /// Index in reverse polish notation array which to jump
    var rpnIndex: Int!
    
    
    // MARK: - Lifecycle
    
    init() {
        self.index = Label.nextIndex()
    }
    
    
    // MARK: - ReversePolishElement
    
    var stringValue: String {
        return description + ":"
    }
    
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return "m" + index.description
    }
    
    static func ==(lhs: Label, rhs: Label) -> Bool {
        return lhs.index == rhs.index
    }
}



// MARK: - Static
extension Label {
    
    fileprivate static var count = 0
    
    
    /// Returns next index
    fileprivate static func nextIndex() -> Int {
        count += 1
        return count
    }
    
    
    /// Set index to zero
    /// Invoke this method every time, when start translating
    static func setIndexToZero() {
        count = 0
    }
}
