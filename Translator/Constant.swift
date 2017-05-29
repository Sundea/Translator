//
//  Constant.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/26/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class Constant: Lexeme, ValueStorable {
    
    var value: Int! {
        return Int(representation)
    }
    
    override init(_ representation: String) {
        super.init(representation)
    }
    
    init(_ value: Int) {
        super.init(value.description)
    }
}


// MARK: - ReversePolishElement
extension Constant: ReversePolishElement {
    var stringValue: String {
        return representation
    }
}
