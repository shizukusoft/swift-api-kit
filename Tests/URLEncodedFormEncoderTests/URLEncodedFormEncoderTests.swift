//
//  URLEncodedFormEncoderTests.swift
//  
//
//  Created by Jaehong Kang on 2022/12/16.
//

import XCTest
@testable import URLEncodedFormEncoder

final class URLEncodedFormEncoderTests: XCTestCase {
    func testEncoderBasic() throws {
        struct Test: Encodable {
            var key: String
        }

        let test = Test(key: "value")

        let encoder = URLEncodedFormEncoder()

        var result: Result<String, Error>?
        measure {
            result = .init {
                try encoder.encode(test)
            }
        }

        try XCTAssertEqual(result?.get(), "key=value")
    }

    func testEncoderDictionary() throws {
        struct NestedTest: Encodable {
            var key: String
        }

        struct Test: Encodable {
            var nestedTest: NestedTest
        }

        let test = Test(nestedTest: .init(key: "value"))

        let encoder = URLEncodedFormEncoder()

        var result: Result<String, Error>?
        measure {
            result = .init {
                try encoder.encode(test)
            }
        }

        try XCTAssertEqual(result?.get(), "nestedTest[key]=value")
    }

    func testEncoderArrayWithBracketsWithoutIndex() throws {
        struct Test: Encodable {
            var key: [String]
        }

        let test = Test(key: ["a", "b", "c"])

        let encoder = URLEncodedFormEncoder()

        encoder.arrayEncodingStrategy = .brackets(withIndex: false)
        var result: Result<String, Error>?
        measure {
            result = .init {
                try encoder.encode(test)
            }
        }
        try XCTAssertEqual(result?.get(), "key[]=a&key[]=b&key[]=c")
    }

    func testEncoderArrayWithBracketsWithIndex() throws {
        struct Test: Encodable {
            var key: [String]
        }

        let test = Test(key: ["a", "b", "c"])

        let encoder = URLEncodedFormEncoder()

        encoder.arrayEncodingStrategy = .brackets(withIndex: true)
        var result: Result<String, Error>?
        measure {
            result = .init {
                try encoder.encode(test)
            }
        }
        try XCTAssertEqual(result?.get(), "key[0]=a&key[1]=b&key[2]=c")
    }

    func testEncoderArrayWithNone() throws {
        struct Test: Encodable {
            var key: [String]
        }

        let test = Test(key: ["a", "b", "c"])

        let encoder = URLEncodedFormEncoder()

        encoder.arrayEncodingStrategy = .none
        var result: Result<String, Error>?
        measure {
            result = .init {
                try encoder.encode(test)
            }
        }
        try XCTAssertEqual(result?.get(), "key=a&key=b&key=c")
    }

    func testEncoderArrayWithCommaSeparated() throws {
        struct Test: Encodable {
            var key: [String]
        }

        let test = Test(key: ["a", "b", "c"])

        let encoder = URLEncodedFormEncoder()

        encoder.arrayEncodingStrategy = .commaSeparated
        var result: Result<String, Error>?
        measure {
            result = .init {
                try encoder.encode(test)
            }
        }
        try XCTAssertEqual(result?.get(), "key=a,b,c")
    }

    func testEncoderArrayWithNestedCommaSeparated() throws {
        struct Test: Encodable {
            var key: [[String: String]]
        }

        let test = Test(key: [["a":"a"], ["b":"b"], ["c":"c"]])

        let encoder = URLEncodedFormEncoder()

        encoder.arrayEncodingStrategy = .commaSeparated
        XCTAssertThrowsError(try encoder.encode(test) as String)
    }

    func testEncoderArrayWithNotAllowed() throws {
        struct Test: Encodable {
            var key: [String]
        }

        let test = Test(key: ["a", "b", "c"])

        let encoder = URLEncodedFormEncoder()

        encoder.arrayEncodingStrategy = .notAllowed
        XCTAssertThrowsError(try encoder.encode(test) as String)
    }
}
