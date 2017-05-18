//
//  Terminal.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/18/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class Terminal: Token, ParsingTableHashable {
    
    // MARK: - ParsingTableHashable
    
    var parsingTableKey: String {
        return self.content
    }
}
