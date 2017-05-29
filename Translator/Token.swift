//
//  Token.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/26/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

struct Token: Equatable, Hashable, CustomStringConvertible {
    
    let lexeme: Lexeme
    let position: TextPoint
    
    init(_ lexeme: Lexeme, _ position: TextPoint) {
        self.lexeme = lexeme
        self.position = position
    }
    
    var hashValue: Int {
        return lexeme.hashValue ^ position.hashValue
    }
    
    static func ==(lhs: Token, rhs: Token) -> Bool {
        return lhs.lexeme == rhs.lexeme && lhs.position == rhs.position
    }
    
    var description: String {
        return "\(position)    \(lexeme)"
    }
}
