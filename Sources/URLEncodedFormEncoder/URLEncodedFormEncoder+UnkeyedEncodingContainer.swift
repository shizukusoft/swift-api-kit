//
//  URLEncodedFormEncoder+UnkeyedEncodingContainer.swift
//  
//
//  Created by Jaehong Kang on 2022/12/14.
//

import Foundation

extension URLEncodedFormEncoder {
    struct _UnkeyedEncodingContainer: _URLEncodedFormEncodingContainer {
        let codingPath: [CodingKey]
        let options: _Options
        let encoder: _Encoder
        let refArray: URLEncodedFormFuture.RefArray
    }
}

extension URLEncodedFormEncoder._UnkeyedEncodingContainer: UnkeyedEncodingContainer {
    var count: Int {
        refArray.array.count
    }

    func encodeNil() throws {
        guard let future = valueFromNil() else {
            return
        }

        refArray.array.append(future)
    }

    func encode(_ value: Bool) throws {
        try refArray.array.append(self.value(from: value))
    }

    func encode(_ value: String) {
        refArray.array.append(.string(value))
    }

    func encode(_ value: Double) {
        self.encode(String(value))
    }

    func encode(_ value: Float) {
        self.encode(String(value))
    }

    func encode(_ value: Int) {
        self.encode(String(value))
    }

    func encode(_ value: Int8) {
        self.encode(String(value))
    }

    func encode(_ value: Int16) {
        self.encode(String(value))
    }

    func encode(_ value: Int32) {
        self.encode(String(value))
    }

    func encode(_ value: Int64) {
        self.encode(String(value))
    }

    func encode(_ value: UInt) {
        self.encode(String(value))
    }

    func encode(_ value: UInt8) {
        self.encode(String(value))
    }

    func encode(_ value: UInt16) {
        self.encode(String(value))
    }

    func encode(_ value: UInt32) {
        self.encode(String(value))
    }

    func encode(_ value: UInt64) {
        self.encode(String(value))
    }

    func encode<T: Encodable>(_ value: T) throws {
        let codingKey = URLEncodedFormEncoder._CodingKey(intValue: count)

        guard let future = try self.value(from: value, for: codingKey) else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: codingPath, debugDescription: "\(T.self) did not encode any values."))
        }

        refArray.array.append(future)
    }

    func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        let newRefDictionary: URLEncodedFormFuture.RefDictionary = [:]
        refArray.array.append(.nestedDictionary(newRefDictionary))

        let codingKey = URLEncodedFormEncoder._CodingKey(intValue: count - 1)

        return KeyedEncodingContainer(
            URLEncodedFormEncoder._KeyedEncodingContainer(
                codingPath: codingPath + [codingKey],
                options: options,
                encoder: encoder(for: codingKey),
                refDictionary: newRefDictionary
            )
        )
    }

    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let newRefArray: URLEncodedFormFuture.RefArray = []
        refArray.array.append(.nestedArray(newRefArray))

        let codingKey = URLEncodedFormEncoder._CodingKey(intValue: count - 1)

        return URLEncodedFormEncoder._UnkeyedEncodingContainer(
            codingPath: codingPath + [URLEncodedFormEncoder._CodingKey(intValue: count - 1)],
            options: options,
            encoder: encoder(for: codingKey),
            refArray: newRefArray
        )
    }

    func superEncoder() -> Encoder {
        let newEncoder = encoder(for: URLEncodedFormEncoder._CodingKey(intValue: count))
        refArray.array.append(.encoder(newEncoder))

        return newEncoder
    }
}
