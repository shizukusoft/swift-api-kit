//
//  OAuth1URLAuthenticatorTests.swift
//  
//
//  Created by Jaehong Kang on 2022/12/11.
//

import XCTest
@testable import APIKitURL
@testable import APIKitOAuth1

final class OAuth1URLAuthenticatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSign() async {
        let credential = OAuth1URLAuthenticator.Credential(
            token: "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",
            tokenSecret: "LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"
        )

        let authenticator = OAuth1URLAuthenticator(
            consumerKey: "xvz1evFS4wEEPTGEFPHBog",
            consumerSecret: "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw",
            credential: credential
        )

        let urlRequest = await authenticator.run { authenticator in
            var urlRequest = URLRequest(url: URL(string: "https://api.twitter.com/1.1/statuses/update.json?include_entities=true")!)
            urlRequest.httpRequestMethod = .post
            urlRequest.httpBody = Data("status=Hello%20Ladies%20%2b%20Gentlemen%2c%20a%20signed%20OAuth%20request%21".utf8)

            measure {
                do {
                    try authenticator.sign(
                        to: &urlRequest,
                        nonce: "kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg",
                        timestamp: 1318622958,
                        oAuthParameters: nil
                    )
                } catch {
                    XCTAssertThrowsError(error)
                }
            }

            return urlRequest
        }

        XCTAssertEqual(
            urlRequest.value(forHTTPHeaderField: "Authorization"),
            #"OAuth oauth_consumer_key="xvz1evFS4wEEPTGEFPHBog",oauth_nonce="kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg",oauth_signature="hCtSmYh%2BiHYCEqBWrE7C7hYmtUk%3D",oauth_signature_method="HMAC-SHA1",oauth_timestamp="1318622958",oauth_token="370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",oauth_version="1.0""#
        )
    }
}
