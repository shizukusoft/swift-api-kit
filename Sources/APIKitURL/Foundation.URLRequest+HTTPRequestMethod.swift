//
//  Foundation.URLRequest+HTTPRequestMethod.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

extension URLRequest {
    public enum HTTPRequestMethod: Equatable, Hashable, Sendable {
        case get
        case post
        case delete
        case put
        case patch
        case other(String)
    }

    /// The HTTP request method of the receiver.
    public var httpRequestMethod: HTTPRequestMethod? {
        get {
            self.httpMethod.flatMap {
                .init($0)
            }
        }
        set {
            self.httpMethod = newValue?.description
        }
    }
}

extension URLRequest.HTTPRequestMethod: LosslessStringConvertible {
    public var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .put:
            return "PUT"
        case .patch:
            return "PATCH"
        case .other(let method):
            return method
        }
    }

    public init(_ description: String) {
        switch description {
        case "GET":
            self = .get
        case "POST":
            self = .post
        case "DELETE":
            self = .delete
        case "PUT":
            self = .put
        case "PATCH":
            self = .patch
        default:
            self = .other(description)
        }
    }
}

extension URLRequest.HTTPRequestMethod: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension URLRequest.HTTPRequestMethod: RawRepresentable {
    public typealias RawValue = String

    public var rawValue: String {
        description
    }

    public init(rawValue: String) {
        self.init(rawValue)
    }
}
