//
//  URLEncodedFormEncoder.swift
//  
//
//  Created by Jaehong Kang on 2022/12/11.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

open class URLEncodedFormEncoder {
    open var boolEncodingStrategy: BoolEncodingStrategy = .literal
    open var nilEncodingStrategy: NilEncodingStrategy = .null
    open var arrayEncodingStrategy: ArrayEncodingStrategy = .brackets(withIndex: false)
    open var dictionaryEncodingStrategy: DictionaryEncodingStrategy = .brackets
    open var userInfo: [CodingUserInfoKey: Any] = [:]

    public func encode<T: Encodable>(_ value: T) throws -> String {
        let options = self.options
        let encoder = _Encoder(codingPath: [], options: options)

        guard let future = try encoder.value(from: value) else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: "Top-level \(T.self) did not encode any values."))
        }

        var urlComponents = URLComponents()
        urlComponents.queryItems = try future.urlQueryItems(options: options)

        guard let query = urlComponents.query else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: "Top-level \(T.self) did not encode any values."))
        }

        return query
    }
}

extension URLEncodedFormEncoder {
    struct _CodingKey: CodingKey, Equatable, Hashable, Sendable {
        static let `super`: Self = .init(stringValue: "super")

        public var stringValue: String
        public var intValue: Int?

        init(stringValue: String, intValue: Int? = nil) {
            self.stringValue = stringValue
            self.intValue = intValue
        }

        init(intValue: Int) {
            self.init(stringValue: "\(intValue)", intValue: intValue)
        }

        init(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = Int(stringValue)
        }
    }

    class _Encoder {
        var codingPath: [CodingKey] = []
        var options: _Options

        var future: URLEncodedFormFuture?

        init(codingPath: [CodingKey], options: _Options) {
            self.codingPath = codingPath
            self.options = options
        }
    }
}

extension URLEncodedFormEncoder._Encoder: Encoder {
    var userInfo: [CodingUserInfoKey: Any] {
        options.userInfo
    }

    func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        if future == nil {
            future = .nestedDictionary([:])
        }

        guard case .nestedDictionary(let refDictionary) = future else {
            preconditionFailure()
        }

        return KeyedEncodingContainer(
            URLEncodedFormEncoder._KeyedEncodingContainer(codingPath: codingPath, options: options, encoder: self, refDictionary: refDictionary)
        )
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        if future == nil {
            future = .nestedArray([])
        }

        guard case .nestedArray(let refArray) = future else {
            preconditionFailure()
        }

        return URLEncodedFormEncoder._UnkeyedEncodingContainer(codingPath: codingPath, options: options, encoder: self, refArray: refArray)
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        URLEncodedFormEncoder._SingleValueEncodingContainer(codingPath: codingPath, options: options, encoder: self)
    }
}

extension URLEncodedFormEncoder._Encoder: _URLEncodedFormEncodingContainer {
    var encoder: URLEncodedFormEncoder._Encoder {
        self
    }
}
