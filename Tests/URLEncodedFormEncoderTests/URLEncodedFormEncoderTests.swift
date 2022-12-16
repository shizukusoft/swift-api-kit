//
//  URLEncodedFormEncoderTests.swift
//  
//
//  Created by Jaehong Kang on 2022/12/16.
//

import XCTest
@testable import URLEncodedFormEncoder

final class URLEncodedFormEncoderTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
        try XCTAssertEqual(result?.get(), "key[0]=a&key[1]=b&key[2]=c")
    }

    func testEncoderArrayWithNotAllowed() throws {
        struct Test: Encodable {
            var key: [String]
        }

        let test = Test(key: ["a", "b", "c"])

        let encoder = URLEncodedFormEncoder()

        encoder.arrayEncodingStrategy = .notAllowed
        var result: Result<String, Error>?
        measure {
            result = .init {
                try encoder.encode(test)
            }
        }
        XCTAssertThrowsError(try result?.get())
    }
}
