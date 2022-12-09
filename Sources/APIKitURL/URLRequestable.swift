//
//  APIURLRequestable.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation

public enum URLRequestablePayload {
    case data(Data)
    case file(URL)
}

public enum URLRequestableRequestType {
    case data(URLRequestablePayload?)
    case upload(URLRequestablePayload)
    case download(URLRequestablePayload?)

    public static var data: Self {
        .data(nil)
    }

    public static var download: Self {
        .download(nil)
    }
}

public protocol URLRequestable {
    typealias RequestType = URLRequestableRequestType
    typealias RequestPayload = URLRequestablePayload

    var urlRequestType: RequestType { get throws }
    var urlRequest: URLRequest { get }
}

extension URLRequestable.RequestPayload {
    public var data: Data {
        get throws {
            switch self {
            case .data(let data):
                return data
            case .file(let url):
                return try Data(contentsOf: url, options: [.mappedIfSafe])
            }
        }
    }
}

extension URLRequestable.RequestType {
    public var requestPayload: URLRequestablePayload? {
        switch self {
        case .data(let urlRequestablePayload):
            return urlRequestablePayload
        case .upload(let urlRequestablePayload):
            return urlRequestablePayload
        case .download(let urlRequestablePayload):
            return urlRequestablePayload
        }
    }
}
