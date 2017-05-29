//
//  TokenExtensions.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/27/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation


extension Terminal: ParsingTableAccesible {
    
    var tableKey: String {
        return representation
    }
}

extension Constant: ParsingTableAccesible {
    var tableKey: String {
        return "@Constant"
    }
}

extension Identifier: ParsingTableAccesible {
    var tableKey: String {
        return "@Identifier"
    }
}

extension Token: ParsingTableAccesible {
    var tableKey: String {
        return (lexeme as! ParsingTableAccesible).tableKey
    }
}
