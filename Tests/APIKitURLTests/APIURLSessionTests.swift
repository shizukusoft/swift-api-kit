//
//  APIURLSessionTests.swift
//  
//
//  Created by Jaehong Kang on 2022/12/22.
//

import XCTest
@testable import APIKitURL

final class APIURLSessionTests: XCTestCase {
    func testBaseURL() async throws {
        struct TestRequest: APIURLRequestable, Encodable {
            typealias RequestBodyType = Self
            typealias ResponseBodyType = TestResponse

            var urlRequest: URLRequest {
                URLRequest(url: URL(string: "v1/apps")!)
            }
        }

        struct TestResponse: Decodable { }

        let apiURLSession = APIURLSession(configuration: .init(baseURL: URL(string: "https://www.example.com/api/")))
        let urlRequest = try await apiURLSession.urlRequest(for: TestRequest(), shouldSign: false)

        XCTAssertEqual(
            urlRequest.url?.absoluteString,
            URL(string: "https://www.example.com/api/v1/apps")?.absoluteString
        )
    }
}
