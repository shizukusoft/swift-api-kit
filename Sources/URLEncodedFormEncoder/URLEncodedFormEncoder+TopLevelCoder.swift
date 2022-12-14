//
//  URLEncodedFormEncoder+TopLevelCoder.swift
//  
//
//  Created by Jaehong Kang on 2022/12/13.
//

import Foundation
import TopLevelCoder

extension URLEncodedFormEncoder: TopLevelEncoder {
    public typealias Output = Data

    public func encode<T: Encodable>(_ value: T) throws -> Data {
        try Data(encode(value).utf8)
    }
}
