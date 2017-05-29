//
//  LexemeFactoryMethod.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/26/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

extension Lexeme {
    
    class func make(_ representation: String, type: LexemeType?) -> Lexeme {
        var result: Lexeme
        
        switch type {
        case let t where t == .identifier:
            result = Identifier(representation)
        case let t where t == .constant:
            result = Constant(representation)
        case let t where t == .terminal:
            
            result = OperatorPool.pool.first { $0.representation == representation }!
        default:
            result = UnknownLexeme(representation)
        }
        
        return result
    }
}
