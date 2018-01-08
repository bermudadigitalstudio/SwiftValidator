//
//  Validator.swift
//  Aurora
//
//  Created by Laurent Gaches on 12/04/2017.
//
//

import Foundation

public enum RuleType {
    case zipCode
    case integer(Int, Int)
    case minLength(Int)
    case iban
    case email
    case double(Double, Double)
    case date(Date, Date, DateFormatter)
    case multiMinLength(CharacterSet, [Int])

    var rule: Rule {
        switch self {
        case .zipCode:
            return ZipCodeRule()
        case .integer(let _min, let _max):
            return IntegerRule(min: min(_min, _max), max: max(_min, _max))
        case .minLength(let min):
            return MinLengthRule(min: min)
        case .iban:
            return IBANRule()
        case .email:
            return EmailRule()
        case .double(let _min, let _max):
            return DoubleRule(min: min(_min, _max), max: max(_min, _max))
        case .date(let low, let high, let f):
            return DateRule(lowBound: low, highBound: high, dateFormatter: f)
        case .multiMinLength(let separator, let length):
            return MultiStringMinLengthRule(separator: separator, length: length)
        }
    }
}

public struct Field {
    let name: String
    let rules: [RuleType]
    let required: Bool

    public init(_ name: String, rules: [RuleType], required: Bool = false) {
        self.name = name
        self.rules = rules
        self.required = required
    }
}

public class Validator {

    private var datas: [String: Any]
    private var validators: [Field] = []
    private var validatedValues: [String: Any] = [:]

    public init(datas: [String: Any]) {
        self.datas = datas
    }

    public func validate(_ fieldName: String, rules: [RuleType], required: Bool = false) {
        validators.append(Field(fieldName, rules: rules, required: required))
    }

    public func validate() -> [String: String] {

        var errors: [String: String] = [:]
        var values: [String: Any] = [:]
        validators.forEach { validator in
            if let fieldValue = datas[validator.name] {
                validator.rules.forEach { ruleType in
                    let rule = ruleType.rule
                    if !rule.validate(value: fieldValue) {
                        errors[validator.name] = rule.errorMessage()
                    } else {
                        values[validator.name] = rule.validatedValue
                    }
                }
            } else {
                if validator.required {
                    errors[validator.name] = "\(validator.name) is required"
                }
            }
        }
        validatedValues = values
        return errors
    }

    public subscript(key: String) -> Any? {
        return validatedValues[key]
    }
}
