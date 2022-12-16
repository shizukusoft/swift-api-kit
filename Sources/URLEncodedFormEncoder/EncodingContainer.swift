//
//  EncodingContainer.swift
//  
//
//  Created by Jaehong Kang on 2022/12/14.
//

protocol _URLEncodedFormEncodingContainer {
    var codingPath: [CodingKey] { get }
    var options: URLEncodedFormEncoder._Options { get }
    var encoder: URLEncodedFormEncoder._Encoder { get }
}

extension _URLEncodedFormEncodingContainer {
    func valueFromNil() -> URLEncodedFormFuture? {
        switch options.nilEncodingStrategy {
        case .nil:
            return .string("nil")
        case .null:
            return .string("null")
        case  .ignore:
            return nil
        }
    }

    func value(from bool: Bool) throws -> URLEncodedFormFuture {
        switch options.boolEncodingStrategy {
        case .numeric:
            return bool ? .string("1") : .string("0")
        case .literal:
            return bool ? .string("true") : .string("false")
        case .custom(let handler):
            return try .string(handler(bool))
        }
    }

    func value(from encodable: Encodable, for additionalKey: CodingKey? = nil) throws -> URLEncodedFormFuture? {
        let encoder = encoder(for: additionalKey)
        try encodable.encode(to: encoder)
        return encoder.future!
    }

    func encoder(for additionalKey: CodingKey? = nil) -> URLEncodedFormEncoder._Encoder {
        guard let additionalKey = additionalKey else {
            return encoder
        }

        return URLEncodedFormEncoder._Encoder(
            codingPath: codingPath + [additionalKey],
            options: options
        )
    }
}
