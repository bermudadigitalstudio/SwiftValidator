import XCTest
@testable import SwiftValidator

class ValidatorTests: XCTestCase {

    func testZipRule() {
        let zipCodeRule = ZipCodeRule()

        XCTAssertTrue(zipCodeRule.validate(value: "meine plz ist 14109 okay"), "PASS")
        XCTAssertEqual(zipCodeRule.validatedValue as? String, "14109")

        XCTAssertTrue(zipCodeRule.validate(value: "31509"), "PASS")
        XCTAssertEqual(zipCodeRule.validatedValue as? String, "31509")

        XCTAssertTrue(zipCodeRule.validate(value: "315000"))
        XCTAssertEqual(zipCodeRule.validatedValue as? String, "31500")

        XCTAssertFalse(zipCodeRule.validate(value: "315"), "TOO SHORT")
        XCTAssertNil(zipCodeRule.validatedValue)

        XCTAssertTrue(zipCodeRule.validate(value: "aR31500"))
        XCTAssertEqual(zipCodeRule.validatedValue as? String, "31500")

        XCTAssertFalse(zipCodeRule.validate(value: "qwert"), "ONLY NUMBERS")

        XCTAssertFalse(zipCodeRule.validate(value: 31500))
        XCTAssertNil(zipCodeRule.validatedValue)
    }

    func testIBANRule() {
        let ibanRule = IBANRule()

        let validIBAN = ["de 44500105175407324931",
                         "DE44500105175407324931",
                         "DE44 5001 0517 5407 3249 31",
                         "GB82 WEST 1234 5698 7654 32",
                         "FR1420041010050500013M02606"]

        validIBAN.forEach {
            XCTAssertTrue(ibanRule.validate(value: $0))
        }

        let invalidIBAN: [Any] = ["A",
                                 "DE4450010517540732493",
                                 44500105,
                                 "ES9121000418450200051332",
                                 "FR1420041010050500013N02606"]

        invalidIBAN.forEach {
            XCTAssertFalse(ibanRule.validate(value: $0))
        }

    }

    func testIntegerRule() {
        let intRule = IntegerRule(min: 10, max: 250)

        [10, 250, 100].forEach {
            XCTAssertTrue(intRule.validate(value: $0))
        }

        [500, 9].forEach {
            XCTAssertFalse(intRule.validate(value: $0))
        }

        ["number is 10", "250 kWh", "I think it was 100 or so"].forEach {
            XCTAssertTrue(intRule.validate(value: $0))
        }

        ["500", "9"].forEach {
            XCTAssertFalse(intRule.validate(value: $0))
        }
    }

    func testEmailRule() {
        let emailRule = EmailRule()

        let validEmails = ["john.appleseed@apple.com", "hello@ap.co", "h@a.co", "hola@c.com.mx"]
        let invalidEmails = ["Hello World", "hello@apple", "helo@a.b"]

        validEmails.forEach {
            XCTAssertTrue(emailRule.validate(value: $0))
        }

        invalidEmails.forEach {
            XCTAssertFalse(emailRule.validate(value: $0))
        }

    }

    func testDoubleRule() {
        let doubleRule = DoubleRule(min: 10, max: 100000)

        [10.0, 250.0, 100.0].forEach {
            XCTAssertTrue(doubleRule.validate(value: $0))
        }

        [5000000.0, 9.0].forEach {
            XCTAssertFalse(doubleRule.validate(value: $0))
        }

        let expected = [90000.56, 250, 100]
        let doubleUSRule = DoubleRule(min: 10, max: 100000, locale: Locale(identifier: "en_US"))
        ["90000.56", "250", "100"].forEach {
            XCTAssertTrue(doubleUSRule.validate(value: $0))
            let value = doubleUSRule.validatedValue as? Double
            XCTAssertTrue(expected.contains(value!))
        }

        ["10,43", "250", "100"].forEach {
            XCTAssertTrue(doubleRule.validate(value: $0))
        }

        ["10,43", "250", "100"].forEach {
            XCTAssertTrue(doubleRule.validate(value: $0))
        }

        ["5000000,0", "9,5"].forEach {
            XCTAssertFalse(doubleRule.validate(value: $0))
        }

        let doubleRuleI18n = DoubleRule(min: 0, max: 100000, locale: Locale(identifier: "en_US"))
        let expectedE = [500.20, 9.5, 1000.56]
        ["500.20", "9.5", "1000.56"].forEach {
            XCTAssertTrue(doubleRuleI18n.validate(value: $0))
            let value = doubleRuleI18n.validatedValue as? Double
            XCTAssertTrue(expectedE.contains(value!))
        }
    }

    func testDateRule() {
        let d1 = Date(timeInterval: -20*60*60*24, since: Date())
        let d2 = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "dd.MM.yyyy"

        let rule = DateRule(lowBound: d1, highBound: d2, dateFormatter: formatter)

        let tenDayBefore: TimeInterval = -10*60*60*24

        do { // correct
            let d3 = Date(timeInterval: tenDayBefore, since: Date())
            XCTAssertTrue(rule.validate(value: formatter.string(from: d3)))
        }

        do { // too young
            let d3 = Date(timeInterval: -30*60*60*24, since: Date())
            XCTAssertFalse(rule.validate(value: formatter.string(from: d3)))
        }

        do { // too old
            let d3 = Date(timeInterval: 30*60*60*24, since: Date())
            XCTAssertFalse(rule.validate(value: formatter.string(from: d3)))
        }

        do { // not a string
            XCTAssertFalse(rule.validate(value: 12345))
        }

        do { // wrong string format
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "de_DE")
            formatter.dateFormat = "yyyy.MM.dd"
            let d3 = Date(timeInterval: tenDayBefore, since: Date())
            XCTAssertFalse(rule.validate(value: formatter.string(from: d3)))
        }
    }

    func testMultiLength() {
        do { // correct
            let rule = MultiStringMinLengthRule(separator: .whitespaces, length: 2, 3)
            XCTAssertTrue(rule.validate(value: "bla bla"))
        }
        do { // correct
            let rule = MultiStringMinLengthRule(separator: .whitespaces, length: 2, 3)
            XCTAssertTrue(rule.validate(value: " bla   bla  "))
        }
        do { // correct with more parts than length constraints
            let rule = MultiStringMinLengthRule(separator: .whitespaces, length: 2, 3)
            XCTAssertTrue(rule.validate(value: "bla bla bla"))
        }
        do { // not a string
            let rule = MultiStringMinLengthRule(separator: .whitespaces, length: 2, 3)
            XCTAssertFalse(rule.validate(value: 234))
        }
        do { // not enough parts
            let rule = MultiStringMinLengthRule(separator: .whitespaces, length: 2, 3, 1)
            XCTAssertFalse(rule.validate(value: "bla bla"))
        }
        do { // part is too short
            let rule = MultiStringMinLengthRule(separator: .whitespaces, length: 2, 4)
            XCTAssertFalse(rule.validate(value: "bla bla"))
        }
    }

    func testValidator() {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "dd.MM.yyyy"

        let v = Validator(datas: [
            "a": "31500",
            "b": "DE44500105175407324931",
            "c": "250",
            "d": "john.appleseed@apple.com",
            "e": "1024,5 kWh",
            "e1": 200,
            "f": "kWh",
            "i": "12.10.1980",
            "j": "Foo Bar"])

        v.validate("a", rules: [.zipCode], required: true)
        v.validate("b", rules: [.iban], required: true)
        v.validate("c", rules: [.integer(1, 1000)], required: true)
        v.validate("d", rules: [.email], required: true)
        v.validate("e", rules: [.double(1, 2000)], required: true)
        v.validate("e1", rules: [.double(1, 2000)], required: true)
        v.validate("f", rules: [.double(1, 2000)], required: true)
        v.validate("g", rules: [.double(1, 2000)], required: true)
        v.validate("h", rules: [.double(1, 2000)], required: false)
        v.validate("i", rules: [.date(formatter.date(from: "01.01.1900")!, formatter.date(from: "01.01.2100")!, formatter)], required: true)
        v.validate("j", rules: [.multiMinLength(.whitespaces, [1, 3])], required: true)

        let errors = v.validate()
        XCTAssert(errors.count == 2)

        XCTAssertEqual(v["a"] as? String, "31500")
        XCTAssertEqual(v["b"] as? String, "DE44500105175407324931")
        XCTAssertEqual(v["c"] as? Int, 250)
        XCTAssertEqual(v["d"] as? String, "john.appleseed@apple.com")
        XCTAssertEqual(v["e"] as? Double, 1024.5)
        XCTAssertEqual(v["e1"] as? Double, 200)
        XCTAssertEqual(v["f"] as? Double, nil)
        XCTAssertEqual(v["i"] as? Date, formatter.date(from: "12.10.1980"))
        XCTAssertEqual(v["j"] as! [String], ["Foo", "Bar"])
    }

    static var allTests = [
        ("testZipRule", testZipRule),
        ("testIBANRule", testIBANRule),
        ("testIntegerRule", testIntegerRule),
        ("testEmailRule", testEmailRule),
        ("testDoubleRule", testDoubleRule),
        ("testDateRule", testDateRule),
        ("testMultiLength", testMultiLength),
        ("testValidator", testValidator)
    ]
}
