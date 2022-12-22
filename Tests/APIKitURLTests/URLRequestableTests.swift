//
//  URLRequestableTests.swift
//  
//
//  Created by Jaehong Kang on 2022/12/23.
//

import XCTest
@testable import APIKitURL

final class URLRequestableTests: XCTestCase {
    func testHTTPStatusCodeValidation() throws {
        let url = URL(string: "http://www.example.com")!
        let urlRequest = URLRequest(url: url)

        for validStatusCode in (200..<400) {
            let validHTTPURLResponse = HTTPURLResponse(
                url: url,
                statusCode: validStatusCode,
                httpVersion: nil,
                headerFields: nil
            )!

            XCTAssertNoThrow(try urlRequest.validateHTTPStatusCode(validHTTPURLResponse))
        }

        for invalidStatusCode in (400..<600) {
            let invalidHTTPURLResponse = HTTPURLResponse(
                url: url,
                statusCode: invalidStatusCode,
                httpVersion: nil,
                headerFields: nil
            )!

            XCTAssertThrowsError(try urlRequest.validateHTTPStatusCode(invalidHTTPURLResponse)) { error in
                XCTAssertEqual(
                    error as? ValidationError,
                    ValidationError.notAllowedStatusCode(
                        invalidStatusCode,
                        context: .init(urlResponse: invalidHTTPURLResponse, httpResponseBody: nil)
                    )
                )
            }
        }
    }
}
