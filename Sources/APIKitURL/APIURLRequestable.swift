//
//  APIURLRequestable.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation
import APIKitCore
@_exported import protocol APIKitCore.Decoder
@_exported import protocol APIKitCore.Encoder

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

public protocol APIURLRequestable<RequestBodyType, ResponseBodyType>: URLRequestable {
    associatedtype RequestBodyType: Encodable
    associatedtype ResponseBodyType: Decodable

    var apiRequestType: APIURLRequestableType<RequestBodyType> { get }

    var requestBodyEncoder: any Encoder<Data> { get }
    var responseBodyDecoder: any Decoder<Data> { get }
}

extension APIURLRequestable {
    var requestBodyEncoder: any Encoder<Data> {
        JSONEncoder()
    }

    var responseBodyDecoder: any Decoder<Data> {
        JSONDecoder()
    }
}

extension APIURLRequestable {
    var requestType: RequestType {
        get throws {
            switch apiRequestType {
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
