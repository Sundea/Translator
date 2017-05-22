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
    
    override var mistakes: [LexerMistake] {
        var mistakes = super.mistakes
        undeclared.forEach { mistakes.append(UndeclaredVariableMistake($0)) }
        redeclared.forEach { mistakes.append(RedeclaredVariableMistake($0)) }
        mistakes.sort(by: <)
        
        return mistakes
    }
    
    
    // MARK: - Private
    
    /// Returns undeclred identifiers
    private var undeclared: [Identifier] {
        let declared = self.declared
        let undeclared = identifiers.filter { identifier in
            return !declared.contains { $0.content == identifier.content }
        }
        return undeclared
    }
    
    
    /// Returns redeclared identifiers
    private var redeclared: [Identifier] {
        let declared = self.declared
        let redeclared = afterKey.filter { !declared.contains($0) }
        return redeclared
    }
    
    
    /// Returns correct declared identifiers (without redeclarated identifiers if they are in result)
    private var declared: [Identifier] {
        var declared =  [Identifier]()
        let afterKeyIdentifiers = afterKey
        for i in 0..<afterKeyIdentifiers.count {
            if !declared.contains(where: { $0.content == afterKeyIdentifiers[i].content }) {
                declared.append(afterKeyIdentifiers[i])
            }
        }
        return declared
    }

    
    /// Returns all identifiers after `var` and `program` non-termianls
    private var afterKey: [Identifier] {
        let afterVar = getIdentifiers(after: "var")
        let afterProgram = getIdentifiers(after: "program")
        return afterProgram + afterVar
    }
    
    
    /// Returns all identifiers between given string and up to `\n`
    ///
    /// - Parameter string: start point of search
    /// - Returns: identifiers between given string and up to `\n` if there are;
    ///     otherwise - empty array
    private func getIdentifiers(after string: String) -> [Identifier] {
        var declared = [Identifier]()
        if let index = result.index(where:  { token in token.content == string }) {
            let slice = result.dropFirst(index)
            var iterator = slice.makeIterator()
            while let next = iterator.next(), next.content != "\n"  {
                if let identifier = next as? Identifier {
                    declared.append(identifier)
                }
            }
        }
        return declared
    }
}
