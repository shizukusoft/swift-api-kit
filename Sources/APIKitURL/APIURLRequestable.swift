//
//  APIURLRequestable.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation
import APIKitCore
@_exported import TopLevelCoder

public enum APIURLRequestableType: Equatable, Hashable, Sendable {
    case data
    case upload
    case download
}

public protocol APIURLRequestable<RequestBodyType, ResponseBodyType>: APIRequestable, URLRequestable {
    var apiURLRequestType: APIURLRequestableType { get }
    var requestBody: RequestBodyType { get }
}

extension APIURLRequestable {
    public var requestBodyEncoder: any TopLevelEncoder<Data> {
        JSONEncoder()
    }

    public var responseBodyDecoder: any TopLevelDecoder<Data> {
        JSONDecoder()
    }

    public var apiURLRequestType: APIURLRequestableType {
        .data
    }
}

extension APIURLRequestable {
    public var urlRequestType: RequestType {
        get throws {
            switch apiURLRequestType {
            case .data:
                return try .data(.data(requestBodyData))
            case .upload:
                return try .upload(.data(requestBodyData))
            case .download:
                return try .download(.data(requestBodyData))
            }
        }
    }
}

extension APIURLRequestable {
    public var requestBodyData: Data {
        get throws {
            try requestBodyEncoder.encode(requestBody)
        }
    }
}

public extension APIURLRequestable where Self: Encodable, RequestBodyType == Self {
    var requestBody: RequestBodyType {
        self
    }
}
