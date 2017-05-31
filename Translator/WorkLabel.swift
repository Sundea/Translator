//
//  WorkLabel.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/30/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class WorkLabel: ReversePolishElement, CustomStringConvertible {
    
    /// Mark index
    let index: Int
    
    /// Index in reverse polish notation array which to jump
    var flag: Int!
    
    
    // MARK: - Lifecycle
    
    init(_ flag: Int) {
        self.index = WorkLabel.nextIndex()
        self.flag = flag
    }
    
    
    // MARK: - ReversePolishElement
    
    var stringValue: String {
        return description
    }
    
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return "r" + index.description
    }
}



// MARK: - Static
extension WorkLabel {
    
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
