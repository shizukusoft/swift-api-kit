//
//  URLRequestableTests.swift
//  
//
//  Created by Jaehong Kang on 2022/12/02.
//

import XCTest
@testable import APIKitURL

final class URLRequestableTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample1() async throws {
//        struct Status: Codable {
//            var status: String
//        }
//
//        struct StatusRequest: APIURLRequestable {
//            typealias RequestBodyType = Status
//            typealias ResponseBodyType = Status
//
//            var urlRequest: URLRequest {
//                var urlRequest = URLRequest(url: URL(string: "https://mastodon.example/api/v1/statuses")!)
//                urlRequest.httpRequestMethod = .post
//
//                return urlRequest
//            }
//
//            var requestBodyEncoder: any Encoder<Data> {
//                JSONEncoder()
//            }
//
//            var responseBodyDecoder: any Decoder<Data> {
//                JSONDecoder()
//            }
//        }
//
//        let session = APIURLSession(configuration: .init(urlSessionConfiguration: .default))
//        let status: Status = try await session.request(StatusRequest())
//    }
//
//    func testExample2() async throws {
//        struct Status: Codable {
//            var status: String
//        }
//
//        struct TimelineRequest: Encodable, APIURLRequestable {
//            typealias RequestBodyType = Self
//            typealias ResponseBodyType = [Status]
//
//            var urlRequest: URLRequest {
//                var urlRequest = URLRequest(url: URL(string: "https://mastodon.example/api/v1/statuses")!)
//                urlRequest.httpRequestMethod = .post
//
//                return urlRequest
//            }
//
//            var requestBodyEncoder: any Encoder<Data> {
//                JSONEncoder()
//            }
//
//            var responseBodyDecoder: any Decoder<Data> {
//                JSONDecoder()
//            }
//
//            var sinceID: String
//        }
//
//        let session = APIURLSession(configuration: .init(urlSessionConfiguration: .default))
//        let statuses: [Status] = try await session.request(TimelineRequest(sinceID: "SOME_ID"))
//    }
}
