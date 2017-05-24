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
    case conflict(left: ParsingTableToken, right: ParsingTableToken, oldRelation: Relation, newRelation: Relation)
    
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






/// Predictive parsing table for syntax analyzer
struct ParsingTable {
    
    /// Describes row in parsing table. Key is right token (column Token) in relation, value is relation.
    fileprivate typealias Row = [String: Relation]
    
    
    // MARK: Properties

    let startEndToken = Terminal("#", TextPoint(line: Int.max, character: Int.max))
    
    /// Container for values
    fileprivate var dictionary = [String: Row]()
    fileprivate var rules: [String: [[String]]]
    
    init(_ rules: [String: [[String]]]) {
        self.rules = rules
    }
    
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return dictionary.description
    }
    
    
    
    // MARK: - Public
    
    /// Accesses the value associated with the given keys for reading.
    ///
    /// - Parameters:
    ///   - rowKey: left token in relation
    ///   - rightKey: right token in relation
    /// - Returns: The value associated with `keys` if `keys` are in the table;
    ///   otherwise, `nil`.
    subscript(rowKey: ParsingTableToken, columnKey: ParsingTableToken) -> Relation? {
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
    func value(for rowKey: ParsingTableToken, _ columnKey: ParsingTableToken) -> Relation? {
        guard let row = dictionary[rowKey.key],
            let value = row[columnKey.key]
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
    mutating func insert(value: Relation?, for rowKey: ParsingTableToken, _ columnKey: ParsingTableToken) throws {
        
        var row = dictionary[rowKey.key] ?? Row()
        
        if let oldRelation = row[columnKey.key], let newRelation = value, oldRelation != newRelation {
            throw ParsingTableError.conflict(left: rowKey, right: columnKey, oldRelation: oldRelation, newRelation: newRelation)
        }
        
        row[columnKey.key] = value
        
        if row.isEmpty {
            dictionary.removeValue(forKey: rowKey.key)
        } else {
            dictionary[rowKey.key] = row
        }
    }

    
    /// Removes the value associated with the given keys for reading.
    ///
    /// - Parameters:
    ///   - rowKey: left token in relation
    ///   - columnKey: right token in relation
    /// - Returns: removed value; otherwise, `nil`
    mutating func removeValue(for rowKey: ParsingTableToken, columnKey: ParsingTableToken) -> Relation? {
        guard var row = dictionary[rowKey.key],
            let value = row.removeValue(forKey: columnKey.key)
            else { return nil }
        
        if row.isEmpty {
            dictionary.removeValue(forKey: rowKey.key)
        }
        
        return value
    }
    
    
    func nonTerminal(for sequence: [String]) -> Key? {
        var result: Key?
    
        for (key, rule) in rules {
            if rule.contains(where: { $0 == sequence }) {
                result = Key(token: key)
                break
            }
        }
        
        return result
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
        let jsonRules = rules as NSDictionary
        let json = NSMutableDictionary()
        json.setValue(jsonRules, forKey: "Rules Dict")
        json.setValue(jsonDict, forKey: "Parsing Table")
        return json
    }
    
    
    /// Initializes from json dictionary
    ///
    /// - Parameters:
    ///   - json: dictionary raw Parsing Table data
    init?(json: [String: Any]) {
        guard let rawDict = json["Parsing Table"] as? [String: [String: String]],
        let rulesDict = json["Rules Dict"] as? [String: [[String]]]
            else { return nil }
        
        self.rules = rulesDict
        for (rowKey, rawrow) in rawDict {
            var row = [String: Relation]()
            
            for (key, value) in rawrow {
                row[key] = Relation(rawValue: value)
            }
            dictionary[rowKey] = row
            
        }
    }
}

