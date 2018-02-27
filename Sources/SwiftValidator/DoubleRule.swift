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
        } else if var s = value as? String {
            // This part of the code makes sure that if we've got a string here
            // that there are no pieces outside what a double might contain.
            // This is so we will not get false validations on strings that contain digits
            // and needs to be here because casting as? Int and as? Dobule
            // are fundamentally flawed in Swift and do not work quite right.
            // So... don't get rid of this without lots of testing

            // Make a character set of digits, commas, and decimal points
            // (Things we could have in a double)
            let doubleCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ".,"))
            // If trimming characters returns anything, we have characters outside of what
            // might be a double, so don't validate it (false)
            guard s.trimmingCharacters(in: doubleCharacters).isEmpty else {
                return false
            }

            let formatter = NumberFormatter()
            formatter.locale = self.locale

            // Trim any thousand separateors to make sure that number formatter will work on linux
            if let hasSeparator = s.trimmingCharacters(in: .decimalDigits).last {
                let sep = String(hasSeparator)
                if sep == "," {
                    s = s.replacingOccurrences(of: ".", with: "")
                } else if sep == "." {
                    s = s.replacingOccurrences(of: ",", with: "")
                }
            }

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
