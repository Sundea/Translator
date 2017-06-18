//
//  RuntimeMistake.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 6/6/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class RuntimeMistake: Mistake {
    
    init(_ explanation: String) {
        let zero = TextPoint(line: 0, character: 0)
        super.init(explanation, zero)
    }
    
    override var description: String {
        return explanation
    }
}
