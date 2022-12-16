//
//  URLEncodedFormEncoder+Strategies.swift
//  
//
//  Created by Jaehong Kang on 2022/12/14.
//

extension URLEncodedFormEncoder {
    public enum BoolEncodingStrategy {
        case numeric
        case literal
        case custom(@Sendable (Bool) throws -> String)
    }

    public enum NilEncodingStrategy {
        case `nil`
        case `null`
        case ignore
    }

    public enum ArrayEncodingStrategy {
        case notAllowed
        case none
        case brackets(withIndex: Bool)

        case custom(@Sendable (Int) throws -> String)
    }

    public enum DictionaryEncodingStrategy {
        case notAllowed
        case brackets
    }
}

extension URLEncodedFormEncoder.ArrayEncodingStrategy {
    func callAsFunction(_ index: Int) throws -> String {
        switch self {
        case .notAllowed:
            preconditionFailure()
        case .none:
            return ""
        case .brackets(withIndex: true):
            return "[\(index)]"
        case .brackets(withIndex: false):
            return "[]"
        case .custom(let handler):
            return try handler(index)
        }
    }
}
