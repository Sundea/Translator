//
//  MyLangLexer.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/22/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class MyLangLexer: Lexer {
    
    // MARK: - Override
    
    override var mistakes: [Mistake]? {
        var mistakes: [Mistake]?
        if let superMistakes = super.mistakes {
            mistakes = superMistakes
        }
        let undeclared = self.undeclared
        let redeclared = self.redeclared
        if !undeclared.isEmpty || !redeclared.isEmpty {
            mistakes = mistakes ?? [Mistake]()
            undeclared.forEach { mistakes!.append(UndeclaredIdentifierMistake($0)) }
            redeclared.forEach { mistakes!.append(RedeclaredIdentifierMistake($0)) }
            mistakes!.sort(by: <)
        }
        
        return mistakes
    }
    
    
    // MARK: - Private
    
    /// Returns undeclred identifiers
    private var undeclared: [Token] {
        let declared = self.declared
        
        let identifiers = result.tokens(from: result.identifiers)
        let undeclared = identifiers.filter { idn in
            return !declared.contains(where: { decIdn in
                return idn.lexeme === decIdn.lexeme
            })
        }
        
        return undeclared
    }
    
    
    /// Returns redeclared identifiers
    private var redeclared: [Token] {
        let declared = self.declared
        var unique = Set<Token>()
        var redeclared = [Token]()
        
        for idn in declared {
            if !unique.contains(where: { $0.lexeme === idn.lexeme } ) {
                unique.insert(idn)
            } else {
                redeclared.append(idn)
            }
        }
        
        return redeclared
    }
    
    
    /// Returns all identifiers between given string and up to `\n`
    ///
    /// - Parameter string: start point of search
    /// - Returns: identifiers between given string and up to `\n` if there are;
    ///     otherwise - empty array
    private var declared: [Token] {
        var declared = [Token]()
        if let index = result.tokens.index(where: { token in token.lexeme.representation == "var" }) {
            let slice = result.tokens.dropFirst(index)
            var iterator = slice.makeIterator()
            while let next = iterator.next(), next.lexeme.representation != ":"  {
                if next.lexeme is Identifier {
                    declared.append(next)
                }
            }
        }
        if let index = result.tokens.index(where: { token in token.lexeme.representation == "program" }) {
            let slice = result.tokens.dropFirst(index)
            var iterator = slice.makeIterator()
            while let next = iterator.next(), next.lexeme.representation != "@"  {
                if next.lexeme is Identifier {
                    declared.append(next)
                    break
                }
            }
        }
        return declared
    }
}
