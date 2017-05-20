//
//  ParsingTable.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/20/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation


/// Parsing table errors
///
/// - conflict: represents conflict situation between keys and associated value
enum ParsingTableError: Error, CustomStringConvertible {
    case conflict(left: ParsingTableHashable, right: ParsingTableHashable, oldRelation: Relation, newRelation: Relation)
    
    var description: String {
        var result: String
        
        switch self {
        case .conflict(let left, let right, let oldRelation, let newRelation):
            result = "Threre is conflict between left token `\(left)` and right token `\(right)`. Trying to replace `\(oldRelation.rawValue)` to `\(newRelation.rawValue)`"
            break
        }
        return result
    }
}


/// Describes relation between two tokens in single order used by predictive parsing table
///
/// - lessThan: left token less than right
/// - moreThan: left token more than right
/// - equal: left token equal right
enum Relation: String {
    case lessThan = "•>"
    case moreThan = "<•"
    case equal = "≐"
}



/// Predictive parsing table for syntax analyzer
struct ParsingTable {
    
    /// Describes row in parsing table. Key is right token (column Token) in relation, value is relation.
    fileprivate typealias Row = [String: Relation]
    

    /// Container for values
    fileprivate var dictionary = [String: Row]()
    
    
    // MARK: - Public
    
    /// Accesses the value associated with the given keys for reading.
    ///
    /// - Parameters:
    ///   - rowKey: left token in relation
    ///   - rightKey: right token in relation
    /// - Returns: The value associated with `keys` if `keys` are in the table;
    ///   otherwise, `nil`.
    subscript(rowKey: ParsingTableHashable, columnKey: ParsingTableHashable) -> Relation? {
        get {
            return value(for: rowKey, columnKey)
        }
    }
    
    
    /// Accesses the value associated with the given keys for reading.
    ///
    /// - Parameters:
    ///   - rowKey: left token in relation
    ///   - columnKey: right token in relation
    /// - Returns: The value associated with `keys` if `keys` are in the table;
    ///   otherwise, `nil`.
    func value(for rowKey: ParsingTableHashable, _ columnKey: ParsingTableHashable) -> Relation? {
        guard let row = dictionary[rowKey.parsingTableKey],
            let value = row[columnKey.parsingTableKey]
            else { return nil }
        
        return value
    }
    
    
    // MARK: Mutating
    
    /// Inserts the given relation value in the table.
    ///
    /// If value is `nil` and there is an element associated with `keys`, it may the same effect as removing relation.
    ///
    /// - Parameters:
    ///   - value: A relation to insert into the table
    ///   - rowKey: left token in relation
    ///   - rightKey: right token in relation
    /// - Throws: If threre is an element is already contained in table for given keys, this
    ///   method throws `ParsingTableError.confict(...)`.
    mutating func insert(value: Relation?, for rowKey: ParsingTableHashable, _ columnKey: ParsingTableHashable) throws {
        
        var row = dictionary[rowKey.parsingTableKey] ?? Row()
        
        if let oldRelation = row[rowKey.parsingTableKey], let newRelation = value {
            throw ParsingTableError.conflict(left: rowKey, right: columnKey, oldRelation: oldRelation, newRelation: newRelation)
        }
        
        row[columnKey.parsingTableKey] = value
        
        if row.isEmpty {
            dictionary.removeValue(forKey: rowKey.parsingTableKey)
        }
    }

    
    /// Removes the value associated with the given keys for reading.
    ///
    /// - Parameters:
    ///   - rowKey: left token in relation
    ///   - columnKey: right token in relation
    /// - Returns: removed value; otherwise, `nil`
    mutating func removeValue(for rowKey: ParsingTableHashable, columnKey: ParsingTableHashable) -> Relation? {
        guard var row = dictionary[rowKey.parsingTableKey],
            let value = row.removeValue(forKey: columnKey.parsingTableKey)
            else { return nil }
        
        if row.isEmpty {
            dictionary.removeValue(forKey: rowKey.parsingTableKey)
        }
        
        return value
    }
}



// MARK: - CustomStringConvertible
extension ParsingTable: CustomStringConvertible {
    
    var description: String {
        return dictionary.description
    }
}



// MARK: - JSON serialiation and deserialization
extension ParsingTable {
    
    /// Returns NSDictionry of raw data, ready for json serialization
    var json: NSDictionary {
        let jsonDict = NSMutableDictionary()
        
        for (rowKey, row) in dictionary {
            let jsonrowDict = NSMutableDictionary()
            
            for (columnKey, relation) in row {
                jsonrowDict.setValue(relation.rawValue, forKey: columnKey)
            }
            
            jsonDict.setValue(jsonrowDict, forKey: rowKey)
        }
        return jsonDict
    }
    
    
    /// Initializes from json dictionary
    ///
    /// - Parameters:
    ///   - json: dictionary raw Parsing Table data
    init?(json: [String: Any]) {
        guard let rawDict = json as? [String: [String: String]] else { return }
        
        for (rowKey, rawrow) in rawDict {
            var row = [String: Relation]()
            
            for (key, value) in rawrow {
                row[key] = Relation(rawValue: value)
            }
            dictionary[rowKey] = row
        }
    }
}

