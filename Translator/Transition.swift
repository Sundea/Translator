//
//  Transition.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/28/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

enum TransitionType: String {
    case falseT = "УПЛ"
    case gotoT = "БП"
}

class Transition: Lexeme, ReversePolishNotation {
    private static var count = 1
    var mark: Int
    var type: TransitionType
    
    init(_ type: TransitionType) {
        self.mark = Transition.count
        self.type = type
        super.init(type.rawValue)
        Transition.count += 1
    }
    
    init(_ transition: Transition) {
        self.mark = transition.mark
        self.type = transition.type
        super.init(type.rawValue)
    }
    
    var snapshot: String {
        return "\(description) \(type.rawValue)"
    }
    
    override var description: String {
        return "m\(mark)"
    }
}

class ContentTransition: Transition {
    
    override var snapshot: String {
        
        return description + ":"
    }
}
