//
//  APIURLSession.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation
import APIKitCore

public actor APIURLSession {
    public nonisolated let urlSession: URLSession
    let urlSessionDelegate: URLSessionDelegate
    public var urlAuthenticator: URLAuthenticator?

    public init(configuration: Configuration) {
        let urlSessionDelegate = URLSessionDelegate()

        self.urlSession = URLSession(configuration: configuration.urlSessionConfiguration, delegate: urlSessionDelegate, delegateQueue: nil)
        self.urlSessionDelegate = urlSessionDelegate

        urlSessionDelegate.apiURLSession = self
    }
}

extension APIURLSession: Session {
    public var authenticator: Authenticator? {
        urlAuthenticator
    }
}

extension APIURLSession {
    public func request(_ request: URLRequestable) async throws -> (URLRequestable.RequestPayload, URLResponse) {
        let urlRequest = request.urlRequest

        switch try request.urlRequestType {
        case .data:
            let data = try await urlSession.data(for: urlRequest)

            return (.data(data.0), data.1)
        case .upload(.data(let data)):
            let upload = try await urlSession.upload(for: urlRequest, from: data)

            return (.data(upload.0), upload.1)
        case .upload(.file(let fileURL)):
            let upload =  try await urlSession.upload(for: urlRequest, fromFile: fileURL)

            return (.data(upload.0), upload.1)
        case .download:
            let download = try await urlSession.download(for: urlRequest)

            return (.file(download.0), download.1)
        }
    }

    public func request(_ request: URLRequestable) async throws -> URLRequestable.RequestPayload {
        try await self.request(request).0
    }
}

extension APIURLSession {
    @_disfavoredOverload
    public func request<R: APIURLRequestable>(_ request: R) async throws -> (R.ResponseBodyType, URLResponse) {
        let response: (URLRequestable.RequestPayload, URLResponse) = try await self.request(request)

        return try (request.responseBodyDecoder.decode(R.ResponseBodyType.self, from: response.0.data), response.1)
    }

    @_disfavoredOverload
    public func request<R: APIURLRequestable>(_ request: R) async throws -> R.ResponseBodyType {
        try await self.request(request).0
    }
}
