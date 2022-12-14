//
//  URLEncodedFormEncoder+KeyedEncodingContainer.swift
//  
//
//  Created by Jaehong Kang on 2022/12/14.
//

import Foundation

extension URLEncodedFormEncoder {
    struct _KeyedEncodingContainer<Key: CodingKey>: _URLEncodedFormEncodingContainer {
        let codingPath: [CodingKey]
        let options: _Options
        let encoder: _Encoder
        let refDictionary: URLEncodedFormFuture.RefDictionary
    }
}

extension URLEncodedFormEncoder._KeyedEncodingContainer: KeyedEncodingContainerProtocol {
    func encodeNil(forKey key: Key) throws {
        refDictionary.dictionary[key.stringValue] = valueFromNil()
    }

    func encode(_ value: Bool, forKey key: Key) throws {
        refDictionary.dictionary[key.stringValue] = try self.value(from: value)
    }

    func encode(_ value: String, forKey key: Key) {
        refDictionary.dictionary[key.stringValue] = .string(value)
    }

    func encode(_ value: Double, forKey key: Key) {
        self.encode(String(value), forKey: key)
    }

    func encode(_ value: Float, forKey key: Key) {
        self.encode(String(value), forKey: key)
    }

    func encode(_ value: Int, forKey key: Key) {
        self.encode(String(value), forKey: key)
    }

    func encode(_ value: Int8, forKey key: Key) {
        self.encode(String(value), forKey: key)
    }

    func encode(_ value: Int16, forKey key: Key) {
        self.encode(String(value), forKey: key)
    }

    func encode(_ value: Int32, forKey key: Key) {
        self.encode(String(value), forKey: key)
    }

    func encode(_ value: Int64, forKey key: Key) {
        self.encode(String(value), forKey: key)
    }

    func encode(_ value: UInt, forKey key: Key) {
        self.encode(String(value), forKey: key)
    }

    func encode(_ value: UInt8, forKey key: Key) {
        self.encode(String(value), forKey: key)
    }

    func encode(_ value: UInt16, forKey key: Key) {
        self.encode(String(value), forKey: key)
    }

    func encode(_ value: UInt32, forKey key: Key) {
        self.encode(String(value), forKey: key)
    }

    func encode(_ value: UInt64, forKey key: Key) {
        self.encode(String(value), forKey: key)
    }

    func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
        refDictionary.dictionary[key.stringValue] = try self.value(from: value, for: key)
    }

    func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        let newRefDictionary: URLEncodedFormFuture.RefDictionary = [:]
        refDictionary.dictionary[key.stringValue] = .nestedDictionary(newRefDictionary)

        return KeyedEncodingContainer(
            URLEncodedFormEncoder._KeyedEncodingContainer(
                codingPath: codingPath + [key],
                options: options,
                encoder: encoder,
                refDictionary: newRefDictionary
            )
        )
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let newRefArray: URLEncodedFormFuture.RefArray = []
        refDictionary.dictionary[key.stringValue] = .nestedArray(newRefArray)

        return URLEncodedFormEncoder._UnkeyedEncodingContainer(
            codingPath: codingPath + [key],
            options: options,
            encoder: encoder(for: key),
            refArray: newRefArray
        )
    }

    func superEncoder() -> Encoder {
        let key = URLEncodedFormEncoder._CodingKey.super

        let newEncoder = encoder(for: key)
        refDictionary.dictionary[key.stringValue] = .encoder(newEncoder)

        return newEncoder
    }

    func superEncoder(forKey key: Key) -> Encoder {
        let newEncoder = encoder(for: key)
        refDictionary.dictionary[key.stringValue] = .encoder(newEncoder)

        return newEncoder
    }
}
