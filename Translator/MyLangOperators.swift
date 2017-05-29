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
    static let read = Terminal("read")
    static let write = Terminal("write")
    
    static let del = Terminal("!")
    static let ifKeyword = ComplexPolishOperator("if", 0, 10, "if")
    static let elseKeyword = SimplePolishOperator("else", 1)
    static let endif = Terminal("endif")
    static let forKeyword = Terminal("for")
    static let to = Terminal("to")
    static let step = Terminal("step")
    static let doKeyword = Terminal("do")
    static let next = Terminal("next")
    static let virgule = Terminal(",")
    static let colon = Terminal(":")
    static let openBracket = Terminal("[")
    static let closeBracket = Terminal("]")
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
    
    
    static let pool: Set<Terminal> = [program, endProgram, varKeyword, begin, end, integer, read, write,ifKeyword, elseKeyword, endif, forKeyword, to, step, doKeyword, next, virgule, colon, openBracket,closeBracket, moreThan, lessThen, moreOrEqualThan, lessOrEqualThan, equal, newLine, openParenthesis, closeParenthesis, assignValue, or, and, not, notEqual, plus, minus, unaryMinus, multiply, divide, power, del]

}