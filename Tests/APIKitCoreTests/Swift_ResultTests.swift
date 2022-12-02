//
//  Swift_ResultTests.swift
//  
//
//  Created by Jaehong Kang on 2022/12/02.
//

import XCTest
@testable import APIKitCore

final class Swift_ResultTests: XCTestCase {
    func testTryMapWithNewSuccess() throws {
        let result = Result<Void, Error>.success(())

        let newValue = UUID()
        let newResult = result.tryMap { _ in
            newValue
        }

        try XCTAssertEqual(newResult.get(), newValue)
    }

    func testTryMapWithNewFailure() throws {
        let result = Result<Void, Error>.success(())

        struct SomeError: Error {}

        let newError = SomeError()
        let newResult = result.tryMap { _ in
            throw newError
        }

        try XCTAssertThrowsError(newResult.get())
    }
}
