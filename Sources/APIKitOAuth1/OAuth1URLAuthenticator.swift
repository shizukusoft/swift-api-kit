//
//  OAuth1URLAuthenticator.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation
import Crypto
import APIKitURL

public actor OAuth1URLAuthenticator {
    public nonisolated let oAuth1: OAuth1
    public var credential: Credential?

    public init(consumerKey: String, consumerSecret: String, credential: Credential? = nil) {
        self.oAuth1 = OAuth1(consumerKey: consumerKey, consumerSecret: consumerSecret)
        self.credential = credential
    }
}

extension OAuth1URLAuthenticator {
    public struct Credential: Equatable, Hashable, Sendable {
        public var token: String
        public var tokenSecret: String
    }
}

extension OAuth1.Token {
    init(_ credential: OAuth1URLAuthenticator.Credential) {
        self.init(token: credential.token, secret: credential.tokenSecret)
    }
}

extension OAuth1URLAuthenticator {
    public func sign(
        to urlRequest: inout URLRequest,
        nonce: String = UUID().uuidString,
        timestamp: TimeInterval = Date().timeIntervalSince1970,
        oAuthParameters: [String: String]?
    ) throws {
        oAuth1.sign(
            token: credential.flatMap { .init($0) },
            to: &urlRequest,
            nonce: nonce,
            timestamp: timestamp,
            additionalOAuthParameters: oAuthParameters
        )
    }
}

extension OAuth1URLAuthenticator: URLAuthenticator {
    public func sign(to urlRequest: inout URLRequest) async throws {
        try self.sign(to: &urlRequest, oAuthParameters: nil)
    }
}
