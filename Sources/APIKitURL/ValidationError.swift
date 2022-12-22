//
//  ValidationError.swift
//  
//
//  Created by Jaehong Kang on 2022/12/22.
//

public enum ValidationError: Error, Equatable, Hashable, Sendable {
    case notAllowedStatusCode(_ code: Int, context: Context)
}

extension ValidationError {
    public struct Context: Equatable, Hashable, Sendable {
        public var urlResponse: URLResponse?
        public var httpResponseBody: URLRequestable.Payload?
    }
}

extension ValidationError {
    var context: Context {
        get {
            switch self {
            case .notAllowedStatusCode(_, let context):
                return context
            }
        }
        mutating set {
            switch self {
            case .notAllowedStatusCode(let code, _):
                self = .notAllowedStatusCode(code, context: newValue)
            }
        }
    }
}
