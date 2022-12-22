//
//  URLEncodedFormEncoder+SingleValueEncodingContainer.swift
//  
//
//  Created by Jaehong Kang on 2022/12/23.
//

extension URLEncodedFormEncoder {
    struct _SingleValueEncodingContainer: _URLEncodedFormEncodingContainer {
        let codingPath: [CodingKey]
        let options: _Options
        let encoder: _Encoder
    }
}

extension URLEncodedFormEncoder._SingleValueEncodingContainer: SingleValueEncodingContainer {
    func encodeNil() {
        encoder.future = valueFromNil()
    }

    func encode(_ value: Bool) throws {
        try encoder.future = self.value(from: value)
    }

    func encode(_ value: String) {
        encoder.future = .string(value)
    }

    func encode(_ value: Double) {
        encode(String(value))
    }

    func encode(_ value: Float) {
        encode(String(value))
    }

    func encode(_ value: Int) {
        encode(String(value))
    }

    func encode(_ value: Int8) {
        encode(String(value))
    }

    func encode(_ value: Int16) {
        encode(String(value))
    }

    func encode(_ value: Int32) {
        encode(String(value))
    }

    func encode(_ value: Int64) {
        encode(String(value))
    }

    func encode(_ value: UInt) {
        encode(String(value))
    }

    func encode(_ value: UInt8) {
        encode(String(value))
    }

    func encode(_ value: UInt16) {
        encode(String(value))
    }

    func encode(_ value: UInt32) {
        encode(String(value))
    }

    func encode(_ value: UInt64) {
        encode(String(value))
    }

    func encode<T: Encodable>(_ value: T) throws {
        encoder.future = try self.value(from: value)
    }
}
