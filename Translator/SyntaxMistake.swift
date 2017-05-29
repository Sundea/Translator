//
//  SyntaxMistake.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/23/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

/// Represents parser error, when there is no relation beetwen current and next tokens.
class SyntaxMistake: Mistake {
    
    init(_ prevToken: Token,_ nextToken: Token) {
        let explanation = "Syntax errror. There is no relation between `\(prevToken.lexeme.representation)` and `\(nextToken.lexeme.representation)`"
        super.init(explanation, nextToken.position)
    }
}
