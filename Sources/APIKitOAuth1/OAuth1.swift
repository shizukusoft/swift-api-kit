//
//  OAuth1.swift
//  
//
//  Created by Jaehong Kang on 2022/12/19.
//

import Foundation
import Crypto
import APIKitURL

public struct OAuth1: Sendable {
    public let consumer: Consumer

    public init(consumer: Consumer) {
        self.consumer = consumer
    }
}

extension OAuth1 {
    public init(consumerKey: String, consumerSecret: String) {
        self.init(consumer: Consumer(key: consumerKey, secret: consumerSecret))
    }
}

extension OAuth1 {
    public struct Consumer: Equatable, Hashable, Sendable {
        public var key: String
        public var secret: String
    }

    public struct Token: Equatable, Hashable, Sendable {
        public var token: String
        public var secret: String
    }
}

extension OAuth1 {
    public func httpAuthorizationHeaderValue(
        for token: Token?,
        httpMethod: String = "GET",
        url: URL,
        parameters: any Sequence<(key: String, value: String)>,
        nonce: String = UUID().uuidString,
        timestamp: TimeInterval = Date().timeIntervalSince1970,
        additionalOAuthParameters: (any Sequence<(key: String, value: String)>)? = nil
    ) -> String {
        let rfc3986UnreservedCharacterSet = CharacterSet.rfc3986Unreserved

        let urlQueryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }

        var oauthQueryItems = [
            URLQueryItem(name: "oauth_consumer_key", value: consumer.key),
            URLQueryItem(name: "oauth_nonce", value: nonce),
            URLQueryItem(name: "oauth_signature_method", value: "HMAC-SHA1"),
            URLQueryItem(name: "oauth_timestamp", value: "\(UInt(timestamp))"),
            URLQueryItem(name: "oauth_version", value: "1.0")
        ]

        if let token = token?.token {
            oauthQueryItems += [URLQueryItem(name: "oauth_token", value: token)]
        }

        if let additionalOAuthParameters {
            oauthQueryItems += additionalOAuthParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        let oauthSignatureParameters = urlQueryItems + oauthQueryItems
        let oauthSignatureParametersString = oauthSignatureParameters
            .sorted(by: {
                if $0.name == $1.name {
                    return $0.value ?? "" < $1.value ?? ""
                } else {
                    return $0.name < $1.name
                }
            })
            .map { [$0.name, $0.value].compactMap { $0?.addingPercentEncoding(withAllowedCharacters: rfc3986UnreservedCharacterSet) } }
            .map { $0.joined(separator: "=") }
            .joined(separator: "&")

        let oauthSignatureBaseString = [
            httpMethod,
            url.absoluteString.addingPercentEncoding(withAllowedCharacters: rfc3986UnreservedCharacterSet),
            oauthSignatureParametersString.addingPercentEncoding(withAllowedCharacters: rfc3986UnreservedCharacterSet)
        ].compactMap { $0 }.joined(separator: "&")

        let oauthSigningKey = [
            consumer.secret.addingPercentEncoding(withAllowedCharacters: rfc3986UnreservedCharacterSet),
            token?.secret.addingPercentEncoding(withAllowedCharacters: rfc3986UnreservedCharacterSet) ?? ""
        ].compactMap { $0 }.joined(separator: "&")

        let authenticationCode = HMAC<Insecure.SHA1>.authenticationCode(
            for: Data(oauthSignatureBaseString.utf8),
            using: .init(data: Data(oauthSigningKey.utf8))
        )

        let oauthSignature = Data(authenticationCode).base64EncodedString()
        oauthQueryItems += [URLQueryItem(name: "oauth_signature", value: oauthSignature)]

        let oauthAuthorization = "OAuth " + oauthQueryItems
            .sorted(by: {
                if $0.name == $1.name {
                    return $0.value ?? "" < $1.value ?? ""
                } else {
                    return $0.name < $1.name
                }
            })
            .map {
                [
                    $0.name.addingPercentEncoding(withAllowedCharacters: rfc3986UnreservedCharacterSet),
                    $0.value?.addingPercentEncoding(withAllowedCharacters: rfc3986UnreservedCharacterSet).flatMap { "\"\($0)\"" }
                ].compactMap { $0 }
            }
            .map { $0.joined(separator: "=") }
            .joined(separator: ",")

        return oauthAuthorization
    }

    public func httpAuthorizationHeaderValue(
        for token: Token?,
        urlRequest: URLRequest,
        nonce: String = UUID().uuidString,
        timestamp: TimeInterval = Date().timeIntervalSince1970,
        additionalOAuthParameters: (any Sequence<(key: String, value: String)>)? = nil
    ) -> String? {
        var bodyURLComponents = URLComponents()
        bodyURLComponents.percentEncodedQuery = urlRequest.httpBody
            .flatMap { String(data: $0, encoding: .utf8) }
        let bodyQueryItems = bodyURLComponents.queryItems ?? []

        var urlComponents = urlRequest.url.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: true) }

        let urlQueryItems = urlComponents?.queryItems ?? []

        urlComponents?.query = nil

        guard let url = urlComponents?.url else {
            return nil
        }

        let parameters: [(key: String, value: String)] = (bodyQueryItems + urlQueryItems).compactMap {
            guard let value = $0.value else {
                return nil
            }

            return (key: $0.name, value: value)
        }

        return httpAuthorizationHeaderValue(
            for: token,
            httpMethod: urlRequest.httpMethod ?? "GET",
            url: url,
            parameters: parameters,
            nonce: nonce,
            timestamp: timestamp,
            additionalOAuthParameters: additionalOAuthParameters
        )
    }
}

extension OAuth1 {
    public func sign(
        token: Token?,
        to urlRequest: inout URLRequest,
        nonce: String = UUID().uuidString,
        timestamp: TimeInterval = Date().timeIntervalSince1970,
        additionalOAuthParameters: (any Sequence<(key: String, value: String)>)? = nil
    ) {
        let oauthAuthorization = httpAuthorizationHeaderValue(
            for: token,
            urlRequest: urlRequest,
            nonce: nonce,
            timestamp: timestamp,
            additionalOAuthParameters: additionalOAuthParameters
        )

        urlRequest.setValue(oauthAuthorization, forHTTPHeaderField: "Authorization")
    }
}
