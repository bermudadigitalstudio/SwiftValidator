//
//  ZipCodeRule.swift
//  Aurora
//
//  Created by Laurent Gaches on 12/04/2017.
//
//

import Foundation

public class ZipCodeRule: Rule {

    public func validate(value: Any) -> Bool {
        guard let value = value as? String, value.characters.count == 5  else { return false }

        guard let regex = try? NSRegularExpression(pattern:"^\\d{5}$", options: []) else { return false }
        let matches = regex.numberOfMatches(in:value, options: .anchored,
                                            range: NSRange(location: 0, length: value.utf8.count))
        return matches == 1
    }

    public func errorMessage() -> String {
        return "Enter a valid 5 digit zipcode"
    }
}
