//
//  UndeclaredIdentifierMistake.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/23/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

/// Repredents undecred Identifer
class UndeclaredIdentifierMistake: Mistake {
    
    init(_ token: Token) {
        let explanation = "Undeclared identifier `\(token.lexeme.representation)`"
        super.init(explanation, token.position)
    }
}
