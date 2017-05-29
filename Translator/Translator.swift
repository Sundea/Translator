//
//  Translator.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/23/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class Translator {
    
    let lexer: Lexer
    let parser: Parser
    
    init(_ lexer: Lexer, _ parser: Parser) {
        self.lexer = lexer
        self.parser = parser
    }
    
    
    func scan() -> [Mistake]? {
        lexer.scan()
        return lexer.mistakes
    }
    
    func parse() -> [Mistake]? {
        parser.input = lexer.result.tokens
        parser.parse()
        let mistakes = parser.mistakes
        return mistakes.isEmpty ? nil : mistakes
    }
    
    func evaluate() {
        
    }
    
    func getProgramContent() -> [Token]? {
        guard let startIndex = lexer.result.tokens.index(where: { $0.lexeme === OperatorPool.del } ),
            let endIndex = lexer.result.tokens.index(where: { $0.lexeme.representation == "end"} )
        else { return nil }
        
        let content = Array(lexer.result.tokens[(startIndex + 1)...(endIndex - 1)])
        return content
    }
}
