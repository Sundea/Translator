//
//  ValueContainter.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/24/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

protocol ValueStorable {
    var value: Int! { get }
}

protocol ValueAccesible: ValueStorable {
    var value: Int! { get set }
    
    func set(_ newValue: Int)
}
