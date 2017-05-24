//
//  Lexer.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/16/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class Lexer {
    
    fileprivate let evaluator: Evaluator
    fileprivate let scanner: TokenScanner
    
    // Count of current scanner line position
    private var line: Int
    
    /// Count of characters in previous line
    private var previousLineCount: Int
    
    
    init(_ code: String) {
        self.evaluator = Evaluator()
        try! self.scanner = ToDelimiterScanner(code, Set(arrayLiteral: " "))
        self.line = 1
        self.previousLineCount = 0
    }
    
    
    // MARK: - Public
    
    /// All tokens produced by scanner
    fileprivate(set) lazy var result = [Token]()
    
    
    /// Return lexer level mistakes sorted by position.
    /// If you want to override this property, don't forget to sort by postition
    var mistakes: [Mistake] {
        var mistakes = [Mistake]()
        let unknownTokens = result.filter() { $0 is UnknownToken } as! [UnknownToken]
        unknownTokens.forEach() { mistakes.append(UnknownTokenMistake($0.position, $0.content)) }
        return mistakes
    }
    
    
    /// Returns all identifiers from result
    var identifiers: [Identifier] {
        return result.filter() { $0 is Identifier } as! [Identifier]
    }
    
    
    /// Returns all terminals from result
    var terminals: [Terminal] {
        return result.filter() { $0 is Terminal } as! [Terminal]
    }
    
    
    /// Returns all constants from result
    var constants: [Constant] {
        return result.filter() { $0 is Constant } as! [Constant]
    }
    
    
    /// Starts to scan. You should invoke this method before getting result property.
    func scan() {
        
        let queue = DispatchQueue(label: "com.translator.lexer", qos: .userInitiated)
        let dipatchGroup = DispatchGroup()
        while let tokenContent = scanner.scanNext() {
            
            let position = self.position(to: scanner.scanLocation, for: tokenContent)
            let type = evaluator.evaluate(tokenContent)
            
            queue.async(group: dipatchGroup) {
                let token = Token.makeToken(with: tokenContent, in: position, by: type)
                self.result.append(token)
            }
        }
        
        dipatchGroup.wait()
    }
    
    
    /// Calculates position of token in the text
    ///
    /// - Parameters:
    ///   - cursorLocation: current scanner location, simply position of last character of the token
    ///   - token: text representation
    /// - Returns: token position in the text
    fileprivate func position(to cursorLocation: Int, for token: String) -> TextPoint {
        let tokenEndChar = cursorLocation - previousLineCount
        let tokenStartChar = tokenEndChar - token.characters.count + 1
        let position = TextPoint(line: line, character: tokenStartChar)
        
        if token == "\n" {
            line += 1
            previousLineCount = scanner.scanLocation
        }
        
        return position
    }
}
