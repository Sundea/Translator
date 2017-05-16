//
//  Token.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/16/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation


/// Represents position in text
struct TextPoint: Hashable, Equatable, CustomStringConvertible {
    
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



/// Represents token
class Token: Hashable, Equatable, CustomStringConvertible {
    
    /// Text representation
    let content: String
    
    /// Position in text
    let position: TextPoint
    
    
    /// Creates token instance
    ///
    /// - Parameters:
    ///   - content: token text repsentation
    ///   - position: token position
    init(_ content: String, position: TextPoint) {
        self.content = content
        self.position = position
    }
    
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return "\(position) \(content)"
    }
    
    
    // MARK: - Hashable
    
    var hashValue: Int {
        return content.hashValue ^ position.hashValue
    }
    
    
    // MARK: - Equatable
    
    static func ==(lhs: Token, rhs: Token) -> Bool {
        return lhs.content == rhs.content && lhs.position == rhs.position
    }
}
