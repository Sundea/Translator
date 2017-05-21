//
//  Terminal.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/18/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class Terminal: Token, ParsingTableToken {
    
    // MARK: - ParsingTableToken
    
    var key: String {
        return self.content
    }
}
