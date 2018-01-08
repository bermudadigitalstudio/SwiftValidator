//
//  ZipCodeRule.swift
//  Aurora
//
//  Created by Laurent Gaches on 12/04/2017.
//
//

import Foundation

public class ZipCodeRule: Rule {

    private(set) public var validatedValue: Any?

    public func validate(value: Any) -> Bool {
        guard let value = value as? String  else { return false }

        guard let regex = try? NSRegularExpression(pattern:"(\\d{5})", options: []) else { return false }
        let matches = regex.matches(in: value, options: .reportCompletion, range:  NSRange(location: 0, length: value.utf8.count))
        var valid: String?

        for match in matches {

            let stringRange =  value.index(value.startIndex, offsetBy: match.range.location)..<value.index(value.startIndex, offsetBy: match.range.location + match.range.length)
            valid = String(value[stringRange])
        }

        guard let validated = valid, matches.count == 1 else {
            validatedValue = nil
            return false
        }

        validatedValue = validated
        return true
    }

    public func errorMessage() -> String {
        return "Enter a valid 5 digit zipcode"
    }
}
