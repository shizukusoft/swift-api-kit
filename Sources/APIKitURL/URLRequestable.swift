//
//  APIURLRequestable.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

public enum URLRequestablePayload: Equatable, Hashable, Sendable {
    case data(Data)
    case file(URL)
}

public enum URLRequestableRequestType: Equatable, Hashable, Sendable {
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
    typealias Payload = URLRequestablePayload

    var urlRequestType: RequestType { get throws }
    var urlRequest: URLRequest { get }

    var allowedHTTPStatusCode: (any Collection<Int>)? { get }
    func validate(responsePayload: URLRequestable.Payload, urlResponse: URLResponse) throws
}

extension URLRequestable {
    public var allowedHTTPStatusCode: (any Collection<Int>)? {
        200..<400
    }

    public func validateHTTPStatusCode(_ urlResponse: URLResponse) throws {
        if
            let allowedHTTPStatusCode,
            let httpURLResponse = urlResponse as? HTTPURLResponse
        {
            guard allowedHTTPStatusCode.contains(httpURLResponse.statusCode) else {
                throw ValidationError.notAllowedStatusCode(httpURLResponse.statusCode, context: .init(urlResponse: urlResponse, httpResponseBody: nil))
            }
        }
    }

    @inlinable
    public func validate(responsePayload: URLRequestable.Payload, urlResponse: URLResponse) throws {
        try validateHTTPStatusCode(urlResponse)
    }
}

extension URLRequestable.Payload {
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
