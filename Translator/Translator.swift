//
//  Translator.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/23/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class Translator {
    
    let code: String
    let lexer: Lexer
    let parser: Parser
    private(set) lazy var mistakes = [Mistake]()
    
    init(_ lexer: Lexer, _ parser: Parser,_ code: String) {
        self.lexer = lexer
        self.parser = parser
        self.code = code
    }
    
    func translate() {
        lexer.scan()
        mistakes = lexer.mistakes
        
        if !mistakes.isEmpty {
            return
        }
    
        let tokens = lexer.result as! [ParsingTableToken]
        parser.input = tokens
        parser.parse()
        mistakes.append(contentsOf: parser.mistakes)
    }
}
