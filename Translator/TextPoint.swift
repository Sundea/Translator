//
//  TextPoint.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/18/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation


/// Represents position in text
struct TextPoint: Hashable, Equatable, CustomStringConvertible {
    
    static let MaxPoint = TextPoint(line: Int.max, character: Int.max)
    
    let line: Int
    let character: Int
    
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return "\(line):\(character)"
    }
    
    
    // MARK: - Hashable
    
    var hashValue: Int {
        return line ^ character
    }
    
    
    // MARK: - Equatable
    
    static func ==(lhs: TextPoint, rhs: TextPoint) -> Bool {
        return lhs.line == rhs.line && lhs.character == rhs.character
    }
}


// MARK: - Comparable
extension TextPoint: Comparable {
    
    static func <(lhs: TextPoint, rhs: TextPoint) -> Bool {
        return (lhs.line == rhs.line) ? lhs.character < rhs.character : lhs.line < rhs.line
    }
    
    static func <=(lhs: TextPoint, rhs: TextPoint) -> Bool {
        return (lhs.line == rhs.line) ? lhs.character <= rhs.character : lhs.line < rhs.line
    }
    
    static func >=(lhs: TextPoint, rhs: TextPoint) -> Bool {
        return (lhs.line == rhs.line) ? lhs.character >= rhs.character : lhs.line > rhs.line
    }
    
    static func >(lhs: TextPoint, rhs: TextPoint) -> Bool {
        return (lhs.line == rhs.line) ? lhs.character > rhs.character : lhs.line > rhs.line
    }
}
