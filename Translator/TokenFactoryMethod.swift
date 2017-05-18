//
//  TokenFactoryMethod.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/18/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation


/// Type of tokens
enum TokenType {
    case identifier
    case terminal
    case constant
}


// MARK: Factory Method
extension Token {
    
    
    /// Creates token subclass based on type
    ///
    /// - Parameters:
    ///   - content: text representation of the token
    ///   - position: position of first (left) character in text
    ///   - type: type of the token
    /// - Returns: token subclass instance if type is specified, otherwise - Token instance
    class func makeToken(with content: String, in position: TextPoint, by type: TokenType?) -> Token {
        var token: Token
        
        if let type = type {
            
            switch type {
            case .constant:
                token = Constant(content, position)
            case .identifier:
                token = Identifier(content, position)
            case .terminal:
                token = Terminal(content, position)
                break
            }
        } else {
            token = Token(content, position)
        }
        
        return token
    }
}
