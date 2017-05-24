//
//  ValueToken.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/24/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class ValueToken: Token {
    fileprivate var storage: Int!
    
    var value: Int! {
        get {
            return storage
        }
    }
}

class Constant: ValueToken, ParsingTableToken {
    
    // MARK: - ParsingTableToken
    
    var key: String {
        return "@Constant"
    }
}

class Identifier: ValueToken, ParsingTableToken {
    
    // MARK: - ParsingTableToken
    
    var key: String {
        return "@Identifier"
    }
    
    func setValue(_ newValue: Int) {
        self.storage = newValue
    }
}
