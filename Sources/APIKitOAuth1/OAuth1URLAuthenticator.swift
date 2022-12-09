//
//  OAuth1URLAuthenticator.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation
import CommonCrypto
import APIKitURL

public actor OAuth1URLAuthenticator {
    public nonisolated let consumerKey: String
    public nonisolated let consumerSecret: String
    public var credential: Credential?

    public init(consumerKey: String, consumerSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
    }
}

extension OAuth1URLAuthenticator {
    public struct Credential {
        public var token: String
        public var tokenSecret: String
    }
}

extension OAuth1URLAuthenticator {
    public func sign(
        to urlRequest: inout URLRequest,
        nonce: String = UUID().uuidString,
        timestamp: TimeInterval = Date().timeIntervalSince1970,
        oAuthParameters: [String: String]?
    ) async throws {
        var bodyURLComponents = URLComponents()
        bodyURLComponents.percentEncodedQuery = urlRequest.httpBody
            .flatMap { String(data: $0, encoding: .utf8) }
        let bodyQueryItems = bodyURLComponents.queryItems ?? []

        var urlComponents = urlRequest.url.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: true) }

        let urlQueryItems = urlComponents?.queryItems ?? []

        urlComponents?.query = nil

        var oauthQueryItems = [
            URLQueryItem(name: "oauth_consumer_key", value: consumerKey),
            URLQueryItem(name: "oauth_nonce", value: nonce),
            URLQueryItem(name: "oauth_signature_method", value: "HMAC-SHA1"),
            URLQueryItem(name: "oauth_timestamp", value: "\(UInt(timestamp))"),
            URLQueryItem(name: "oauth_version", value: "1.0")
        ]

        if let token = credential?.token {
            oauthQueryItems += [URLQueryItem(name: "oauth_token", value: token)]
        }

        if let oAuthParameters {
            oauthQueryItems += oAuthParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        let oauthSignatureParameters = bodyQueryItems + urlQueryItems + oauthQueryItems
        let oauthSignatureParametersString = oauthSignatureParameters
            .sorted(by: {
                if $0.name == $1.name {
                    return $0.value ?? "" < $1.value ?? ""
                } else {
                    return $0.name < $1.name
                }
            })
            .map { [$0.name, $0.value].compactMap { $0?.addingPercentEncoding(withAllowedCharacters: .rfc3986Allowed) } }
            .map { $0.joined(separator: "=") }
            .joined(separator: "&")

        let oauthSignatureBaseString = [
            "\((urlRequest.httpMethod ?? "GET").uppercased())",
            urlComponents?.url?.absoluteString.addingPercentEncoding(withAllowedCharacters: .rfc3986Allowed),
            oauthSignatureParametersString.addingPercentEncoding(withAllowedCharacters: .rfc3986Allowed)
        ].compactMap { $0 }.joined(separator: "&")

        let oauthSigningKey = [
            consumerSecret.addingPercentEncoding(withAllowedCharacters: .rfc3986Allowed),
            credential?.tokenSecret.addingPercentEncoding(withAllowedCharacters: .rfc3986Allowed) ?? ""
        ].compactMap { $0 }.joined(separator: "&")

        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), oauthSigningKey, oauthSigningKey.count, oauthSignatureBaseString, oauthSignatureBaseString.count, &digest)

        let oauthSignature = Data(digest).base64EncodedString(options: [])
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
                    $0.name.addingPercentEncoding(withAllowedCharacters: .rfc3986Allowed),
                    $0.value?.addingPercentEncoding(withAllowedCharacters: .rfc3986Allowed).flatMap { "\"\($0)\"" }
                ].compactMap { $0 }
            }
            .map { $0.joined(separator: "=") }
            .joined(separator: ",")

        urlRequest.setValue(oauthAuthorization, forHTTPHeaderField: "Authorization")
    }
}

extension OAuth1URLAuthenticator: URLAuthenticator {
    public func sign(to urlRequest: inout URLRequest) async throws {
        try await self.sign(to: &urlRequest, oAuthParameters: nil)
    }
}
