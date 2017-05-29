//
//  UnexpectedEndOfFile.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/23/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class UnexpectedEndOfFile: Mistake {
    
    init(_ token: Token) {
        let explanation = "Unexpected end of file `\(token.lexeme.representation)`"
        super.init(explanation, token.position)
    }
}
