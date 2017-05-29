//
//  UnknownTokenMistake.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/23/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

/// Repredents token, that lexer can't match to any type
class UnknownTokenMistake: Mistake {
    
    init(_ token: Token) {
        let explanation = "Unknown lexeme `\(token.lexeme.representation)`"
        super.init(explanation, token.position)
    }
}
