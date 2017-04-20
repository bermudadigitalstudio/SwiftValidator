//
//  IBANRule.swift
//  Validator
//
//  Created by Laurent Gaches on 19/04/2017.
//
//

import Foundation

public class IBANRule: Rule {

    private let defaultsFormats = ["DE":"DE\\d{20}","GB":"GB\\d{2}[A-Z]{4}\\d{14}", "FR":"FR\\d{12}[A-Z0-9]{11}\\d{2}"]

    /// Validate an International Bank Account Number (IBAN)
    ///
    /// see https://en.wikipedia.org/wiki/International_Bank_Account_Number
    ///
    /// - Parameter value: the IBAN to validate.
    /// - Returns: `true` if the IBAN is valid.
    public func validate(value: Any) -> Bool {

        guard let value = value as? String else { return false }

        let valueSanitized = value.components(separatedBy: .whitespacesAndNewlines).joined(separator: "").uppercased()

        guard valueSanitized.characters.count > 8 && valueSanitized.characters.count < 34 else { return false }

        let countryIndex = valueSanitized.index(valueSanitized.startIndex, offsetBy: 2)
        let countryCode = valueSanitized.substring(to: countryIndex).uppercased()

        guard let format =  defaultsFormats[countryCode] else { return false }

        guard let regex = try? NSRegularExpression(pattern:format, options: []) else { return false }
        let matches = regex.numberOfMatches(in:valueSanitized, options: .anchored,
                                            range: NSRange(location: 0, length: valueSanitized.utf8.count))

        guard matches == 1 else { return false }

        return checkDigits(value: valueSanitized)
    }

    public func errorMessage() -> String {
        return "Enter a valid IBAN"
    }


    /// Validating the IBAN
    ///
    ///  see https://en.wikipedia.org/wiki/International_Bank_Account_Number#Validating_the_IBAN
    ///
    /// - Parameter value: the IBAN
    /// - Returns: `true` if it passed the test
    func checkDigits(value: String) -> Bool {

        // Move the four initial characters to the end of the string
        let permuteIndex = value.index(value.startIndex, offsetBy: 4)
        let permuteStr = value.substring(from: permuteIndex) + value.substring(to: permuteIndex)


        // Replace each letter in the string with two digits, thereby expanding the string, where A = 10, B = 11, ..., Z = 35
        var tocheck = String()
        permuteStr.unicodeScalars.forEach { charValue in
            if CharacterSet.letters.contains(charValue) {
                tocheck.append("\(Int(charValue.value) - 55)")
            } else {
                tocheck.append(String(charValue))
            }
        }

        // Interpret the string as a decimal integer and compute the remainder of that number on division by 97
        guard let remainder = mod97(input: tocheck) else { return false }
        return remainder == 1
    }


    /// Compute MOD 97
    ///
    /// see https://en.wikipedia.org/wiki/International_Bank_Account_Number#Modulo_operation_on_IBAN
    ///
    /// - Parameter input: IBAN the string as a decimal integer
    /// - Returns: the remainder
    func mod97(input: String) -> Int? {
        var remaining = input
        while true {
            let chunkSize = remaining.characters.count < 9 ? remaining.characters.count : 9

            if let chunk = Int(remaining.substring(with: Range<String.Index>( remaining.startIndex..<remaining.index(remaining.startIndex, offsetBy: chunkSize)))) {
                if chunk < 97 || remaining.characters.count < 3 {
                    break
                }

                let remainder = chunk % 97
                remaining = "\(remainder)\(remaining.substring(from:  remaining.index(remaining.startIndex, offsetBy: chunkSize)))"
            } else {
                break
            }
            
        }

        return Int(remaining)
    }
}

