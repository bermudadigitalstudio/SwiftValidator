//
//  DateRule.swift
//  SwiftValidator
//
//  Created by Maxim Zaks on 11.09.17.
//
//

import Foundation

public class DateRule: Rule {
    let bound: ClosedRange<Date>
    let formatter: DateFormatter
    
    private var error: String?
    
    public var validatedValue: Any?
    
    public init(lowBound: Date, highBound: Date, dateFormatter: DateFormatter) {
        self.bound = lowBound < highBound ? lowBound...highBound : highBound...lowBound
        self.formatter = dateFormatter
    }
    
    public func validate(value: Any) -> Bool {
        
        guard let string = value as? String,
            let date = formatter.date(from: string) else {
                error = "\(value) is not a valid date"
                return false
        }
        guard bound.contains(date) else {
            error = "\(value) is not a in range \(bound)"
            return false
        }
        validatedValue = date
        return true
    }
    
    public func errorMessage() -> String {
        return error ?? ""
    }
}
