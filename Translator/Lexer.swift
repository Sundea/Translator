//
//  Lexer.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/16/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class Lexer {
    
    let evaluator: Evaluator
    let scanner: TokenScanner
    var line: Int
    var previousLineCount: Int
    
    init(_ code: String) {
        self.evaluator = Evaluator()
        try! self.scanner = ToDelimiterScanner(code, Set(arrayLiteral: " "))
        self.line = 1
        self.previousLineCount = 0
    }
    
    func produce() -> [Token] {
        var result = [Token]()
        
        while !scanner.isAtEnd {
            if let tokenContent = scanner.scanNext() {
                
                let tokenEndChar = scanner.scanLocation - previousLineCount
                let tokenStartChar = tokenEndChar - tokenContent.characters.count + 1
                let position = TextPoint(line: line, character: tokenStartChar)
                let type = evaluator.evaluate(tokenContent)
                
                if tokenContent == "\n" {
                    line += 1
                    previousLineCount = scanner.scanLocation
                }
                
                let token = Token.makeToken(with: tokenContent, in: position, by: type)
                result.append(token)
            }
        }
        
        return result
    }
}
