
//
//  ViewController.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/16/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Cocoa


extension Notification.Name {
    static let successfulTranslation = Notification.Name("Successful translation")
    static let startTranslation = Notification.Name("Start translating")
    static let parser = Notification.Name("Parser")
}


class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        code.font = NSFont(name: "Menlo-Regular", size: 12.0)
        console.font = NSFont(name: "Menlo-Regular", size: 11.0)
        NotificationCenter.default.addObserver(self, selector: #selector(startTranslation(_:)), name: .startTranslation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(successfulTranslation(_:)), name: .successfulTranslation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(writeVariable(_:)), name: .writeToConsole, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showParserLogs(_:)), name: .parser, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .startTranslation, object: nil)
        NotificationCenter.default.removeObserver(self, name: .successfulTranslation, object: nil)
        NotificationCenter.default.removeObserver(self, name: .writeToConsole, object: nil)
        NotificationCenter.default.removeObserver(self, name: .parser, object: nil)
    }
    
    // MARK: IBOutlets
    
    @IBOutlet var code: NSTextView!
    @IBOutlet var console: NSTextView!
    
    
    // MARK: - Propperties
    
    var translator: Translator!
    var parser: RPNParser!
    
    var parsingTable: ParsingTable {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("test.json")
        
        let readData = try! Data.init(contentsOf: fileURL)
        let dict = try! JSONSerialization.jsonObject(with: readData) as! [String: Any]
        return ParsingTable(json: dict)!
    }
    
    lazy var parsingTableWindowController: NSWindowController = {
        let storyboard = NSStoryboard(name: "Parsing Table", bundle: nil)
        return storyboard.instantiateInitialController() as! NSWindowController
    }()
    
    lazy var reversePolishNotationWC: NSWindowController = {
        let storyboard = NSStoryboard(name: "Reverse Polisch Notation", bundle: nil)
        return storyboard.instantiateInitialController() as! NSWindowController
    }()
    
    var parsingTableVC: ParsingTableViewController {
        let window = parsingTableWindowController.window!
        return window.contentViewController as! ParsingTableViewController
    }
    
    var reversePolishNotationTableVC: ReversePolishNotationViewController {
        let window = reversePolishNotationWC.window!
        return window.contentViewController as! ReversePolishNotationViewController
    }
}



// MARK: - NSTextViewDelegate
extension ViewController: NSTextViewDelegate {
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    
            let tabSpace = "    "
            
            if commandSelector == #selector(insertTab(_:)) {
                let location = code.selectedRange
                code.insertText(tabSpace, replacementRange: location)
                return true
            }
            return false
    
    }
}



// MARK: - IBActions
extension ViewController {
    @IBAction func showParsingTableWindow(sender: AnyObject) {
        if let translator = translator {
            parsingTableVC.snaphots = translator.parser.snapshots
        }
        parsingTableWindowController.showWindow(self)
    }
    
    @IBAction func showReversePolishNotationResultWindow(sender: AnyObject) {
        if let parser = parser {
            reversePolishNotationTableVC.parsingSnaphots = parser.snapshots
        }
        reversePolishNotationWC.showWindow(self)
    }
    
    @IBAction func run(_ sender: Any?) {
        
        if let code = self.code.string, !code.isEmpty {
            NotificationCenter.default.post(name: .startTranslation, object: nil)
            
            translator = MyTranslator(code, parsingTable)
            if let lexerMistakes = translator.scan() {
                print(lexerMistakes)
            } else if let parsingMistakes = translator.parse() {
                print(parsingMistakes)
            } else {
                NotificationCenter.default.post(name: .successfulTranslation, object: nil)
                var input = Queue<Token>(translator.getProgramContent()!)
                parser = RPNParserController(&input)
                let _ = parser.parse()
                NotificationCenter.default.post(name: .parser, object: nil)
            }
        } else {
            let noCodeMistake = Mistake("There is nothing to translate", TextPoint(line: 1, character: 1))
            print([noCodeMistake])
        }
    }
}

extension ViewController {
    func startTranslation(_ notification: Notification) {
        clearConsole()
        print(at: Date(), "Start translation...", with: NSColor.black)
        if let window = parsingTableWindowController.window, window.isVisible {
            parsingTableVC.snaphots = nil
        }
    }
    
    func successfulTranslation(_ notification: Notification) {
        print(at: Date(), "Translation Successful", with: NSColor.black)
        if let window = parsingTableWindowController.window, window.isVisible {
            parsingTableVC.snaphots = translator.parser.snapshots
        }
    }
    
    func showParserLogs(_ notification: Notification) {
        if let window = reversePolishNotationWC.window, window.isVisible {
            reversePolishNotationTableVC.parsingSnaphots = parser.snapshots
        }
    }
    
    func writeVariable(_ notification: Notification) {
        if notification.name == .writeToConsole {
            if let variables = notification.userInfo?["tokens"] as? [Token] {
                if variables.count > 1 {
                    var representation = ""
                    for variable in variables {
                        let con = variable.lexeme as! ValueStorable
                        representation.append("\(con.value!) ")
                    }
                    printToConsole(representation, with: NSColor.black)
                } else {
                    let first = variables.first!
                    if let con = first.lexeme as? ValueStorable, let value = con.value {
                        printToConsole("\(value)", with: NSColor.black)
                    } else {
                        printToConsole("\(first.position)    Variable `\(first.lexeme.representation)` not initialized yet", with: NSColor.red)
                    }
                }
            }
        }
    }
    
    
    
    func readVariable(_ name: String) -> String  {
        let alert = NSAlert()
        alert.messageText = "Input `\(name)` value"
        alert.addButton(withTitle: "OK")
        let textField = NSTextField(frame: NSMakeRect(0, 0, 200, 24))
        textField.stringValue = ""
        alert.accessoryView = textField
        let _ = alert.runModal()
        return textField.stringValue
    }
}


extension ViewController {
    func print(_ mistakes: [Mistake]) {
        var mistakeString = mistakes.reduce("") { result, next in "\(result)\n\(next)" }
        let fromIndex = mistakeString.index(after: mistakeString.startIndex)
        mistakeString = mistakeString.substring(from: fromIndex)
        printToConsole(mistakeString, with: NSColor.red)
    }
    
    func printToConsole(_ string:String, with color: NSColor) {
        let attributedString = NSAttributedString(string: "\(string)\n", attributes: [NSForegroundColorAttributeName: color])
        console.textStorage?.append(attributedString)
    }
    
    func printWithoutNewline(_ string:String, with color: NSColor) {
        let attributedString = NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName: color])
        console.textStorage?.append(attributedString)
    }
    
    func print(at date: Date, _ string: String, with color: NSColor) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        printToConsole("\(hour):\(minutes):\(seconds)    \(string)", with: color)
    }
    
    func clearConsole() {
        console.string = ""
    }
}

