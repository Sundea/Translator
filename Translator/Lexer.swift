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
        self.result = TokenCollection()
    }
    
    
    // MARK: - Public
    
    var result: TokenCollection
    
    
    
    /// Return lexer level mistakes sorted by position.
    /// If you want to override this property, don't forget to sort by postition
    var mistakes: [Mistake]? {
        if !result.unknowns.isEmpty {
            let unknownTokens = result.tokens(from: result.unknowns)
            let mistakes = unknownTokens.map { UnknownTokenMistake($0) }
            return mistakes
        }
        return nil
    }
    
    
    /// Starts to scan. You should invoke this method before getting result property.
    func scan() {
        
        let queue = DispatchQueue(label: "com.translator.lexer", qos: .userInitiated)
        let dipatchGroup = DispatchGroup()
        while let tokenContent = scanner.scanNext() {
            
            let position = self.position(to: scanner.scanLocation, for: tokenContent)
            let type = evaluator.evaluate(tokenContent)
            
            queue.async(group: dipatchGroup) { [unowned self] in
                
                let token = Lexeme.make(tokenContent, type: type)
                self.result.append(token, at: position)
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
        
        if token == OperatorPool.newLine.representation {
            line += 1
            previousLineCount = scanner.scanLocation
        }
        
        return position
    }
}
