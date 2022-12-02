//
//  APIURLSession.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation

public actor APIURLSession {
    public nonisolated let urlSession: URLSession
    let urlSessionDelegate: URLSessionDelegate

    public init(configuration: Configuration) {
        let urlSessionDelegate = URLSessionDelegate()

        self.urlSession = URLSession(configuration: configuration.urlSessionConfiguration, delegate: urlSessionDelegate, delegateQueue: nil)
        self.urlSessionDelegate = urlSessionDelegate

        urlSessionDelegate.apiURLSession = self
    }
}

extension APIURLSession {
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func request(_ request: URLRequestable) async throws -> (URLRequestable.RequestPayload, URLResponse) {
        let urlRequest = request.urlRequest

        switch try request.requestType {
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

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func request(_ request: URLRequestable) async throws -> URLRequestable.RequestPayload {
        try await self.request(request).0
    }

    public func request(_ request: URLRequestable, completionHandler: @escaping (Result<(URLRequestable.RequestPayload, URLResponse), Error>) -> Void) {
        let urlRequest = request.urlRequest

        do {
            switch try request.requestType {
            case .data:
                urlSession.dataTask(with: urlRequest) { data, urlResponse, error in
                    guard let data, let urlResponse else {
                        completionHandler(.failure(error!))
                        return
                    }

                    completionHandler(.success((.data(data), urlResponse)))
                }.resume()
            case .upload(.data(let data)):
                urlSession.uploadTask(with: urlRequest, from: data) { data, urlResponse, error in
                    guard let data, let urlResponse else {
                        completionHandler(.failure(error!))
                        return
                    }

                    completionHandler(.success((.data(data), urlResponse)))
                }
                .resume()
            case .upload(.file(let fileURL)):
                urlSession.uploadTask(with: urlRequest, fromFile: fileURL) { data, urlResponse, error in
                    guard let data, let urlResponse else {
                        completionHandler(.failure(error!))
                        return
                    }

                    completionHandler(.success((.data(data), urlResponse)))
                }
                .resume()
            case .download:
                urlSession.downloadTask(with: urlRequest) { url, urlResponse, error in
                    guard let url, let urlResponse else {
                        completionHandler(.failure(error!))
                        return
                    }

                    completionHandler(.success((.file(url), urlResponse)))
                }
                .resume()
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
}

extension APIURLSession {
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @_disfavoredOverload
    public func request<R: APIURLRequestable>(_ request: R) async throws -> (R.ResponseBodyType, URLResponse) {
        let response: (URLRequestable.RequestPayload, URLResponse) = try await self.request(request)

        return try (request.responseBodyDecoder.decode(R.ResponseBodyType.self, from: response.0.data), response.1)
    }

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @_disfavoredOverload
    public func request<R: APIURLRequestable>(_ request: R) async throws -> R.ResponseBodyType {
        try await self.request(request).0
    }

    @_disfavoredOverload
    public func request<R: APIURLRequestable>(_ request: R, completionHandler: @escaping (Result<(R.ResponseBodyType, URLResponse), Error>) -> Void) {
        self.request(request as URLRequestable) { result in
            completionHandler(
                result.tryMap {
                    try (request.responseBodyDecoder.decode(R.ResponseBodyType.self, from: $0.0.data), $0.1)
                }
            )
        }
    }
}
