//
//  TokenCollection.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/26/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class TokenCollection {
    /// Returns all identifiers from result
    private(set) lazy var identifiers = Set<Identifier>()
    
    /// Returns all terminals from result
    private(set) lazy var terminals = Set<Terminal>()
    
    /// Returns all constants from result
    private(set) lazy var constants = Set<Constant>()
    
    private(set) lazy var unknowns = Set<UnknownLexeme>()
    
    private(set) lazy var tokens = [Token]()
    
    
    func append(_ lexeme: Lexeme, at position: TextPoint) {
        var token: Token
        
        switch lexeme {
        case let l as Identifier:
            identifiers.insert(l)
            let lexeme = identifiers.first { $0.representation == l.representation }
            token = Token(lexeme!, position)
        case let term as Terminal:
            let lex = (OperatorPool.pool.first { term == $0 })!
            terminals.insert(lex)
            token = Token(lex, position)
        case let const as Constant:
            constants.insert(const)
            let lexeme = constants.first { $0.representation == const.representation }
            token = Token(lexeme!, position)
        default:
            let unk = lexeme as! UnknownLexeme
            unknowns.insert(unk)
            let unkLexeme = unknowns.first { $0.representation == unk.representation }
            token = Token(unkLexeme!, position)
        }
    
        tokens.append(token)
    }
    
    
    func tokens(from lexemas: Set<Lexeme>) -> [Token] {
        return tokens.filter { lexemas.contains($0.lexeme) }
    }
}

