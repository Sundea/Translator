//
//  UnexpectedEndOfFile.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/23/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class UnexpectedEndOfFile: Mistake {
    
    override var description: String {
        return "\(position)    Unexpected end of file."
    }
}
