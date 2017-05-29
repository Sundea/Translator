//
//  MyTranslator.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/28/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class MyTranslator: Translator {
    
    init(_ code: String, _ parsingTable: ParsingTable) {
        let lexer = MyLangLexer(code)
        let parser = Parser(parsingTable)
        super.init(lexer, parser)
    }
    
}
