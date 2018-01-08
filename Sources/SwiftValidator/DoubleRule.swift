//
//  DoubleRule.swift
//  SwiftValidator
//
//  Created by Maxim Zaks on 07.09.17.
//
//

import Foundation
public class DoubleRule: Rule {

    private let min: Double
    private let max: Double
    private let locale: Locale

    private(set) public var validatedValue: Any?

    public init(min: Double, max: Double, locale: Locale? = nil) {
        self.min = min
        self.max = max
        if let locale = locale {
            self.locale = locale
        } else {
            self.locale = Locale(identifier: "de_DE")
        }
    }

    public func validate(value: Any) -> Bool {
        var number: Double?
        if let d = value as? Double {
            number = d
        } else if let s = value as? String {

            let formatter = NumberFormatter()
            formatter.locale = self.locale

            if let num = formatter.number(from: s) {
                number = num.doubleValue
            } else {
                number = parseNumber(s)
            }

        } else if let i = value as? Int {
            number = Double(i)
        }

        guard let n = number, n >= min, n <= max  else { return false }

        validatedValue = n

        return true
    }

    public func errorMessage() -> String {
        return "Enter a valid number between \(min) and \(max)"
    }
}
