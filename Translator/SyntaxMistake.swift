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
    let nextToken: String
    
    init(_ position: TextPoint, _ token: String, _ nextToken: String) {
        self.nextToken = nextToken
        super.init(position, token)
    }
    
    
    // MARK: - CustomStringConvertible
    
    override var description: String {
        return "\(position)    Syntax errror. There is no relation between `\(token!)` and `\(nextToken)`"
    }
}
