//
//  RPNLabelKeeper.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/29/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class RPNLabelKeeper: ComplexPolishOperator {
    lazy var labels = [Label]()
    
    override var stringValue: String {
        let labelsStingValue = labels.reduce("") { result, next in "\(result) \(next)" }
        return super.stringValue + labelsStingValue
    }
}
