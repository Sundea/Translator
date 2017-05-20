//
//  ParsingTable.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/20/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

enum Relation: String {
    case lessThan = ">"
    case moreThan = "<"
    case equal = "≐"
}


struct ParsingTable {
    
    fileprivate var container = [String: [String: Relation]]()
    
    public subscript(leftKey: ParsingTableHashable, rightKey: ParsingTableHashable) -> Relation? {
        get {
            return value(for: leftKey, rightKey)
        }
        set (newValue) {
            insert(value: newValue, for: leftKey, rightKey)
        }
    }
    
    
    mutating func insert(value: Relation?, for leftKey: ParsingTableHashable, _ rightKey: ParsingTableHashable) {
        
        if var line = container[leftKey.parsingTableKey] {
            line[rightKey.parsingTableKey] = value
            
            if line.count == 0 {
                container.removeValue(forKey: leftKey.parsingTableKey)
            }
        } else if value != nil  {
            var line = [String: Relation]()
            line[rightKey.parsingTableKey] = value
            
            container[leftKey.parsingTableKey] = line
        }
    }
    
    
    func value(for leftKey: ParsingTableHashable, _ rightKey: ParsingTableHashable) -> Relation? {
        guard let line = container[leftKey.parsingTableKey],
            let value = line[rightKey.parsingTableKey]
            else { return nil }
        
        return value
    }
    
    
    mutating func removeValue(for leftKey: ParsingTableHashable, rightKey: ParsingTableHashable) -> Relation? {
        guard var line = container[leftKey.parsingTableKey],
            let value = line.removeValue(forKey: rightKey.parsingTableKey)
            else { return nil }
        
        if line.isEmpty {
            container.removeValue(forKey: leftKey.parsingTableKey)
        }
        
        return value
    }
}
