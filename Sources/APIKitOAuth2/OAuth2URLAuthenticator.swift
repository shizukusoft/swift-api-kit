//
//  OAuth2URLAuthenticator.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation
import APIKitURL

public actor OAuth2URLAuthenticator {
    public var credential: Credential?

    public init() { }
}

extension OAuth2URLAuthenticator: URLAuthenticator {
    public func sign(to urlRequest: inout URLRequest) async throws {
        if let credential {
            urlRequest.setValue([credential.tokenType, credential.accessToken].joined(separator: " "), forHTTPHeaderField: "Authorization")
        }
    }
}

extension OAuth2URLAuthenticator {
    public struct Credential {
        public var tokenType: String
        public var accessToken: String

        public var refreshToken: String?
    }
}
