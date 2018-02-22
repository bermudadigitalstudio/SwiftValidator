//
//  IntegerRule.swift
//  Aurora
//
//  Created by Laurent Gaches on 12/04/2017.
//
//

import Foundation

public class IntegerRule: Rule {

    let min: Int
    let max: Int

    private(set) public var validatedValue: Any?

    public init(min: Int, max: Int) {
        self.min = min
        self.max = max
    }

    public func validate(value: Any) -> Bool {
        var number: Int?
        if let i = value as? Int {
            number = i
        } else if let s = value as? String,
            let d = parseNumber(s) {

            // This part of the code makes sure that if we've got a string here
            // that there are no pieces outside what a double might contain.
            // This is so we will not get false validations on strings that contain digits
            // and needs to be here because casting as? Int and as? Dobule
            // are fundamentally flawed in Swift and do not work quite right.
            // So... don't get rid of this without lots of testing

            // (Things we could have in int)
            let intChars = CharacterSet.decimalDigits
            // If trimming characters returns anything, we have characters outside of what
            // might be an Int, so don't validate it (false)
            guard s.trimmingCharacters(in: intChars).isEmpty else {
                return false
            }

            number = Int(d)
        }
        guard let n = number, n >= min, n <= max  else { return false }
        validatedValue = n
        return true
    }

    public func errorMessage() -> String {
        return "Enter a valid number between \(min) and \(max)"
    }
}
