//
//  MyLangOperators.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/26/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

struct OperatorPool {
//    ["program", "@", "var", "begin", "end", "integer", "read", "write", "if", "else", "endif", "or", "and", "not", "for", "to", "step", "do", "next", ",", ":", ":=", "-", "+", "*", "/", "^", "(", ")", "[", "]", "<", ">", "<=", ">=", "==", "<>", "\\n", " ", "\\t"]
    static let program = Terminal("program")
    static let endProgram = Terminal("@")
    static let varKeyword = Terminal("var")
    static let begin = Terminal("begin")
    static let end = Terminal("end")
    static let integer = Terminal("integer")
    static let read = SimplePolishOperator("read", 0)
    static let write = SimplePolishOperator("write", 0)
    
    static let del = Terminal("!")
    static let ifKeyword = ComplexPolishOperator("if", 0, 10, "if")
    static let then = SimplePolishOperator("then", 1)
    static let elseKeyword = SimplePolishOperator("else", 1)
    static let endif = Terminal("endif")
    static let forKeyword = ComplexPolishOperator("for", 0, 10, "for")
    static let to = SimplePolishOperator("to", 1)
    static let step = SimplePolishOperator("step", 1)
    static let doKeyword = SimplePolishOperator("do", 1)
    static let next = Terminal("next")
    static let virgule = Terminal(",")
    static let colon = Terminal(":")
    static let openBracket = ComplexPolishOperator("[", 0, 10, "[")
    static let closeBracket = SimplePolishOperator("]", 1)
    static let moreThan = SimplePolishOperator(">", 6, ">")
    static let lessThen = SimplePolishOperator("<", 6, "<")
    static let moreOrEqualThan = SimplePolishOperator(">=", 6, ">=")
    static let lessOrEqualThan = SimplePolishOperator("<=", 6, "<=")
    static let equal = SimplePolishOperator("==", 6, "==")
    static let newLine = Terminal("\\n")
    static let openParenthesis = ComplexPolishOperator("(", 0, 10, "(")
    static let closeParenthesis = SimplePolishOperator(")", 1)
    static let assignValue = ComplexPolishOperator(":=", 2, 10, ":=")
    static let or = SimplePolishOperator("or", 3, "or")
    static let and = SimplePolishOperator("and", 4, "and")
    static let not = SimplePolishOperator("not", 5, "not")
    static let notEqual = SimplePolishOperator("<>", 6, "<>")
    static let plus = SimplePolishOperator("+", 7, "+")
    static let minus = SimplePolishOperator("-", 7, "-")
    static let unaryMinus = SimplePolishOperator("-", 8, "@")
    static let multiply = SimplePolishOperator("*", 8, "*")
    static let divide = SimplePolishOperator("/", 8, "/")
    static let power = SimplePolishOperator("^", 9, "^")
    
    static let pool: Set<Terminal> = [program, endProgram, varKeyword, begin, end, integer, read, write, ifKeyword, then, elseKeyword, endif, forKeyword, to, step, doKeyword, next, virgule, colon, openBracket,closeBracket, moreThan, lessThen, moreOrEqualThan, lessOrEqualThan, equal, newLine, openParenthesis, closeParenthesis, assignValue, or, and, not, notEqual, plus, minus, unaryMinus, multiply, divide, power, del]

}
