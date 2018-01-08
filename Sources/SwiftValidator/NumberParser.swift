//
//  NumberParser.swift
//  SwiftValidator
//
//  Created by Maxim Zaks on 07.09.17.
//
//

import Foundation

public func parseNumber(_ s: String, floatSeparator: CChar = 44 /*,*/, thousandSeparator: CChar = 46 /*.*/) -> Double? {
    var couldBeMinus = false
    var isMinus = false
    var isNumber = false
    var isFloat = false

    var intPart = 0
    var floatPart = 0
    var divider = 1

    for c in s.utf8CString {
        if (CChar(48)...CChar(57)).contains(c) { // 0...9
            if couldBeMinus {
                isMinus = true
                couldBeMinus = false
            }
            isNumber = true
            let n = Int(c - 48)
            if isFloat {
                floatPart = floatPart * 10 + n
                divider *= 10
                continue
            }
            intPart = intPart * 10 + n
            continue
        }
        if c == floatSeparator {
            if isNumber && isFloat == false {
                isFloat = true
            } else {
                if isFloat {
                    break
                }
            }
            continue
        }
        if c == 45 { // -
            if isNumber {
                break
            }
            couldBeMinus = !couldBeMinus
            continue
        }
        if c != 32 { // Space
            couldBeMinus = false
        }
        if c == thousandSeparator && isFloat == false {
            continue
        }
        if isNumber {
            break
        }
    }

    let multiplicator = isMinus ? -1.0 : 1.0

    guard isNumber else {
        return nil
    }

    return (Double(intPart) + (Double(floatPart) / Double(divider))) * multiplicator
}
