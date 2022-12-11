//
//  APIRequestable.swift
//  
//
//  Created by Jaehong Kang on 2022/12/10.
//

import Foundation

public protocol APIRequestable<RequestBodyType, ResponseBodyType> {
    associatedtype RequestBodyType: Encodable
    associatedtype ResponseBodyType: Decodable

    var requestBodyEncoder: any TopLevelEncoder<Data> { get }
    var responseBodyDecoder: any TopLevelDecoder<Data> { get }
}
