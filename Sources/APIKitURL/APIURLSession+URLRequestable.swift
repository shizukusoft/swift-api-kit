//
//  APIURLSession+Request.swift
//  
//
//  Created by Jaehong Kang on 2022/12/11.
//

import APIKitCore

extension APIURLSession {
    @_disfavoredOverload
    public nonisolated func request(_ request: URLRequestable, shouldSign: Bool = false) async throws -> (URLRequestable.Payload, URLResponse) {
        var urlRequest = request.urlRequest

        if
            let urlAuthenticator = await self.urlAuthenticator,
           shouldSign
        {
            try await urlAuthenticator.sign(to: &urlRequest)
        }

        if
            let urlString = urlRequest.url?.absoluteString,
            let baseURL = configuration.baseURL
        {
            urlRequest.url = URL(string: urlString, relativeTo: baseURL)
        }

        switch try request.urlRequestType {
        case .data, .download:
            if
                urlRequest.httpBody == nil
            {
                urlRequest.httpBody = try request.urlRequestType.requestPayload?.data
            }
        case .upload(.data), .upload(.file):
            break
        }

        let response: (URLRequestable.Payload, URLResponse)

        switch try request.urlRequestType {
        case .data:
            let data = try await urlSession.data(for: urlRequest)

            response = (.data(data.0), data.1)
        case .upload(.data(let data)):
            let upload = try await urlSession.upload(for: urlRequest, from: data)

            response = (.data(upload.0), upload.1)
        case .upload(.file(let fileURL)):
            let upload =  try await urlSession.upload(for: urlRequest, fromFile: fileURL)

            response = (.data(upload.0), upload.1)
        case .download:
            let download = try await urlSession.download(for: urlRequest)

            response = (.file(download.0), download.1)
        }

        do {
            try request.validate(responsePayload: response.0, urlResponse: response.1)
        } catch {
            guard var error = error as? ValidationError else {
                throw error
            }

            if error.context.httpResponseBody == nil {
                error.context.httpResponseBody = response.0
            }

            throw error
        }

        return response
    }

    @_disfavoredOverload
    public nonisolated func request(_ request: URLRequestable, shouldSign: Bool = false) async throws -> URLRequestable.Payload {
        try await self.request(request, shouldSign: shouldSign).0
    }
}
