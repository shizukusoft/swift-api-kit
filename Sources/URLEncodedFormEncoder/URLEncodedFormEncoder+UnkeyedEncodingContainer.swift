//
//  URLEncodedFormEncoder+UnkeyedEncodingContainer.swift
//  
//
//  Created by Jaehong Kang on 2022/12/14.
//

extension URLEncodedFormEncoder {
    struct _UnkeyedEncodingContainer: _URLEncodedFormEncodingContainer {
        let codingPath: [CodingKey]
        let options: _Options
        let encoder: _Encoder
        let refArray: URLEncodedFormFuture.RefArray
    }
}

extension URLEncodedFormEncoder._UnkeyedEncodingContainer {
    private func append(_ newElement: URLEncodedFormFuture, for value: Any) throws {
        if case .notAllowed = options.arrayEncodingStrategy {
            throw EncodingError.invalidValue(value, .init(codingPath: codingPath, debugDescription: "Array is not allowed."))
        }

        append(newElement)
    }

    private func append(_ newElement: URLEncodedFormFuture) {
        refArray.array.append(newElement)
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

        try append(future, for: Optional<Any>.none as Any)
    }

    func encode(_ value: Bool) throws {
        try append(self.value(from: value), for: value)
    }

    func encode(_ value: String) throws {
        try append(.string(value), for: value)
    }

    func encode(_ value: Double) throws {
        try self.encode(String(value))
    }

    func encode(_ value: Float) throws {
        try self.encode(String(value))
    }

    func encode(_ value: Int) throws {
        try self.encode(String(value))
    }

    func encode(_ value: Int8) throws {
        try self.encode(String(value))
    }

    func encode(_ value: Int16) throws {
        try self.encode(String(value))
    }

    func encode(_ value: Int32) throws {
        try self.encode(String(value))
    }

    func encode(_ value: Int64) throws {
        try self.encode(String(value))
    }

    func encode(_ value: UInt) throws {
        try self.encode(String(value))
    }

    func encode(_ value: UInt8) throws {
        try self.encode(String(value))
    }

    func encode(_ value: UInt16) throws {
        try self.encode(String(value))
    }

    func encode(_ value: UInt32) throws {
        try self.encode(String(value))
    }

    func encode(_ value: UInt64) throws {
        try self.encode(String(value))
    }

    func encode<T: Encodable>(_ value: T) throws {
        let codingKey = URLEncodedFormEncoder._CodingKey(intValue: count)

        guard let future = try self.value(from: value, for: codingKey) else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: codingPath, debugDescription: "\(T.self) did not encode any values."))
        }

        try append(future, for: value)
    }

    func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        let newRefDictionary: URLEncodedFormFuture.RefDictionary = [:]
        append(.nestedDictionary(newRefDictionary))

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
        append(.nestedArray(newRefArray))

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
        append(.encoder(newEncoder))

        return newEncoder
    }
}
