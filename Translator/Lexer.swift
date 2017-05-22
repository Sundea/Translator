//
//  Lexer.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/16/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class Lexer {
    
    private let evaluator: Evaluator
    private let scanner: TokenScanner
    private var line: Int
    private var previousLineCount: Int
    private(set) lazy var result = [Token]()
    
    init(_ code: String) {
        self.evaluator = Evaluator()
        try! self.scanner = ToDelimiterScanner(code, Set(arrayLiteral: " "))
        self.line = 1
        self.previousLineCount = 0
    }
    
    
    func produce() {

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
    
    func position(to scanLocation: Int, for token: String) -> TextPoint {
        let tokenEndChar = scanLocation - previousLineCount
        let tokenStartChar = tokenEndChar - token.characters.count + 1
        let position = TextPoint(line: line, character: tokenStartChar)
        
        if token == "\n" {
            line += 1
            previousLineCount = scanner.scanLocation
        }
        
        return position
    }
}
