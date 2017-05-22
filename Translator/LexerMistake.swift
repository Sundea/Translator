//
//  LexerMistake.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/22/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation


/// Represent mistake on lexer level check
class LexerMistake: CustomStringConvertible, Equatable, Hashable {

    /// Incorrect token
    let token: Token
    
    
    init(_ token: Token) {
        self.token = token
    }
    
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return "\(token)    Generic lexer error."
    }
    
    
    // MARK: - Equtable
    
    static func ==(lhs: LexerMistake, rhs: LexerMistake) -> Bool {
        return lhs.token == rhs.token
    }
    
    
    // MARK: - Hashable
    
    var hashValue: Int {
        return token.hashValue
    }
}


// MARK: - Comparable
extension LexerMistake: Comparable {
    
    static func <(lhs: LexerMistake, rhs: LexerMistake) -> Bool {
        return lhs.token.position < rhs.token.position
    }
    
    static func <=(lhs: LexerMistake, rhs: LexerMistake) -> Bool {
        return lhs.token.position <= rhs.token.position
    }

    static func >=(lhs: LexerMistake, rhs: LexerMistake) -> Bool {
        return lhs.token.position >= rhs.token.position
    }

    static func >(lhs: LexerMistake, rhs: LexerMistake) -> Bool {
        return lhs.token.position > rhs.token.position
    }

}


/// Repredents undecred Identifer
class UndeclaredVariableMistake: LexerMistake {
    override var description: String {
        return "\(token)    Undeclared variable."
    }
}


/// Repredents redeclared Identifer
class RedeclaredVariableMistake: LexerMistake {
    override var description: String {
        return "\(token)    Redeclared variable."
    }
}


/// Repredents token, that lexer can't match to any type
class UnknownTokenMistake: LexerMistake {
    override var description: String {
        return "\(token)    Unknown token."
    }
}
