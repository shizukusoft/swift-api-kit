//
//  APIURLRequestable.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation
import APIKitCore
@_exported import TopLevelCoder

public enum APIURLRequestableType<RequestBodyType: Encodable> {
    case data(RequestBodyType?)
    case upload(RequestBodyType)
    case download(RequestBodyType?)

    public static var data: Self {
        .data(nil)
    }

    public static var download: Self {
        .download(nil)
    }
}

public protocol APIURLRequestable<RequestBodyType, ResponseBodyType>: APIRequestable, URLRequestable {
    var apiURLRequestType: APIURLRequestableType<RequestBodyType> { get }
}

extension APIURLRequestable {
    var requestBodyEncoder: any TopLevelEncoder<Data> {
        JSONEncoder()
    }

    var responseBodyDecoder: any TopLevelDecoder<Data> {
        JSONDecoder()
    }

    var apiURLRequestType: APIURLRequestableType<RequestBodyType> {
        .data
    }
}

extension APIURLRequestable {
    var urlRequestType: RequestType {
        get throws {
            switch apiURLRequestType {
            case .data(let requestBody):
                let payload = try requestBody.flatMap {
                    try RequestPayload.data( requestBodyEncoder.encode($0))
                }

                return .data(payload)
            case .upload(let requestBody):
                return try .upload(.data(requestBodyEncoder.encode(requestBody)))
            case .download(let requestBody):
                let payload = try requestBody.flatMap {
                    try RequestPayload.data( requestBodyEncoder.encode($0))
                }

                return .download(payload)
            }
        }
    }
}

extension APIURLRequestable where Self: Encodable, RequestBodyType == Self { }
