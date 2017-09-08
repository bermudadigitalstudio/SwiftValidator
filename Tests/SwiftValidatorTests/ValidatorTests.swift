import XCTest
@testable import SwiftValidator

class ValidatorTests: XCTestCase {

    func testZipRule() {
        let zipCodeRule = ZipCodeRule()

        XCTAssertTrue(zipCodeRule.validate(value: "31500"), "PASS")
        XCTAssertFalse(zipCodeRule.validate(value: "315000"), "TOO LONG")
        XCTAssertFalse(zipCodeRule.validate(value: "315"), "TOO SHORT")
        XCTAssertFalse(zipCodeRule.validate(value: "aR31500"), "WRONG FORMAT")
        XCTAssertFalse(zipCodeRule.validate(value: "qwert"), "ONLY NUMBERS")
        XCTAssertFalse(zipCodeRule.validate(value: 31500))
    }

    func testIBANRule() {
        let ibanRule = IBANRule()

        let validIBAN = ["DE44500105175407324931",
                         "DE44 5001 0517 5407 3249 31",
                         "GB82 WEST 1234 5698 7654 32",
                         "FR1420041010050500013M02606"]

        validIBAN.forEach {
            XCTAssertTrue(ibanRule.validate(value: $0))
        }

        let invalidIBAN:[Any] = ["A",
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

        [10,250,100].forEach {
            XCTAssertTrue(intRule.validate(value: $0))
        }

        [500,9].forEach {
            XCTAssertFalse(intRule.validate(value: $0))
        }
        
        ["number is 10","250 kWh","I think it was 100 or so"].forEach {
            XCTAssertTrue(intRule.validate(value: $0))
        }
        
        ["500","9"].forEach {
            XCTAssertFalse(intRule.validate(value: $0))
        }
    }

    func testEmailRule() {
        let emailRule = EmailRule()

        let validEmails = ["john.appleseed@apple.com", "hello@ap.co", "h@a.co", "hola@c.com.mx"]
        let invalidEmails = ["Hello World","hello@apple", "helo@a.b"]

        validEmails.forEach {
            XCTAssertTrue(emailRule.validate(value: $0))
        }

        invalidEmails.forEach {
            XCTAssertFalse(emailRule.validate(value: $0))
        }

    }
    
    func testDoubleRule() {
        let intRule = DoubleRule(min: 10, max: 250)
        
        [10.0,250.0,100.0].forEach {
            XCTAssertTrue(intRule.validate(value: $0))
        }
        
        [500.0,9.0].forEach {
            XCTAssertFalse(intRule.validate(value: $0))
        }
        
        ["10,43","250","100"].forEach {
            XCTAssertTrue(intRule.validate(value: $0))
        }
        
        ["500,0","9,5"].forEach {
            XCTAssertFalse(intRule.validate(value: $0))
        }
    }
    
    func testValidator() {
        let v = Validator(datas: [
            "a": "31500",
            "b": "DE44500105175407324931",
            "c": "250",
            "d": "john.appleseed@apple.com",
            "e": "1024,5 kWh",
            "e1": 200,
            "f": "kWh"])
        
        v.validate("a", rules: [.zipCode], required: true)
        v.validate("b", rules: [.iban], required: true)
        v.validate("c", rules: [.integer(1, 1000)], required: true)
        v.validate("d", rules: [.email], required: true)
        v.validate("e", rules: [.double(1, 2000)], required: true)
        v.validate("e1", rules: [.double(1, 2000)], required: true)
        v.validate("f", rules: [.double(1, 2000)], required: true)
        v.validate("g", rules: [.double(1, 2000)], required: true)
        v.validate("h", rules: [.double(1, 2000)], required: false)
        
        let errors = v.validate()
        XCTAssert(errors.count == 2)
        
        XCTAssertEqual(v["a"] as? String, "31500")
        XCTAssertEqual(v["b"] as? String, "DE44500105175407324931")
        XCTAssertEqual(v["c"] as? Int, 250)
        XCTAssertEqual(v["d"] as? String, "john.appleseed@apple.com")
        XCTAssertEqual(v["e"] as? Double, 1024.5)
        XCTAssertEqual(v["e1"] as? Double, 200)
        XCTAssertEqual(v["f"] as? Double, nil)
    }

    static var allTests = [
        ("testZipRule", testZipRule),
        ("testIBANRule", testIBANRule),
        ("testIntegerRule", testIntegerRule),
        ("testEmailRule", testEmailRule),
        ("testDoubleRule", testDoubleRule),
        ("testValidator", testValidator)
    ]
}
