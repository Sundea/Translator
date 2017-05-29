//
//  AllTokensViewController.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/28/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Cocoa

class AllTokensViewController: NSViewController {

    var tokens:[Token]! {
        didSet {
            table.reloadData()
        }
    }
    
    @IBOutlet weak var table: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func lexemeType(of lexeme: Lexeme) -> String {
        switch lexeme {
        case _ as Identifier:
            return "Identifier"
        case _ as Terminal:
            return "Terminal"
        case _ as Constant:
            return "Constant"
        default:
            return "Unknown"
        }
    }
    
}

extension AllTokensViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = tableColumn else { return nil }
        let textCell = tableView.make(withIdentifier: column.identifier, owner: self) as? NSTableCellView ?? NSTableCellView()
        
        let token = tokens[row]
        var stringValue = ""
        switch column.identifier {
        case "Lexeme":
            stringValue = token.lexeme.representation
        case "Count":
            stringValue = row.description
        case "Type":
            stringValue = lexemeType(of: token.lexeme)
        default:
            break
        }
        
        textCell.textField?.stringValue = stringValue
        return textCell
    }
}

extension AllTokensViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
         return tokens?.count ?? 0
    }
}
