//
//  Label.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/29/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

struct Label: ReversePolishElement, CustomStringConvertible {
    
    /// Mark index
    let index: Int
    
    /// Command that mark points to
    var commands: [ReversePolishElement]
    
    
    // MARK: - Lifecycle
    
    init(_ commands: [ReversePolishElement]) {
        self.index = Mark.nextIndex()
        self.commands = commands
    }
    
    
    // MARK: - ReversePolishElement
    
    var representation: String {
        return description + ":" + commands.reduce("") { result, next in "\(result) \(next)" }
    }
    
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return "m" + index.description
    }
}



// MARK: - Static
extension Label {
    
    fileprivate static var count = 1
    
    
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
