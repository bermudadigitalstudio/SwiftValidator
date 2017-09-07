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
        guard let value = value as? String, value.characters.count == 5  else { return false }

        guard let regex = try? NSRegularExpression(pattern:"^\\d{5}$", options: []) else { return false }
        let matches = regex.numberOfMatches(in:value, options: .anchored,
                                            range: NSRange(location: 0, length: value.utf8.count))
        
        let valid = matches == 1
        
        if valid {
            validatedValue = value
        }
        return valid
    }

    public func errorMessage() -> String {
        return "Enter a valid 5 digit zipcode"
    }
}
