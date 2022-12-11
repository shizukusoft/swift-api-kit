//
//  APIURLSession+Request.swift
//  
//
//  Created by Jaehong Kang on 2022/12/11.
//

import APIKitCore

extension APIURLSession {
    @_disfavoredOverload
    public nonisolated func request(_ request: URLRequestable, shouldSign: Bool = false) async throws -> (URLRequestable.RequestPayload, URLResponse) {
        var urlRequest = request.urlRequest

        if
            let urlAuthenticator = await self.urlAuthenticator,
           shouldSign
        {
            try await urlAuthenticator.sign(to: &urlRequest)
        }

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

    @_disfavoredOverload
    public nonisolated func request(_ request: URLRequestable, shouldSign: Bool = false) async throws -> URLRequestable.RequestPayload {
        try await self.request(request, shouldSign: shouldSign).0
    }
}
