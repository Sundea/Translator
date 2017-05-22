//
//  Token.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/16/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation


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
    init(_ content: String, _ position: TextPoint) {
        self.content = content
        self.position = position
    }
    
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return "\(position)   \(content)"
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
