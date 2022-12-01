//
//  Encoder.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation

#if canImport(Combine)
import Combine

public protocol Encoder<Output>: TopLevelEncoder {
    /// The type this encoder produces.
    associatedtype Output

    /// Encodes an instance of the indicated type.
    ///
    /// - Parameter value: The instance to encode.
    func encode<T>(_ value: T) throws -> Self.Output where T : Encodable
}
#else
public protocol Encoder<Output> {
    /// The type this encoder produces.
    associatedtype Output

    /// Encodes an instance of the indicated type.
    ///
    /// - Parameter value: The instance to encode.
    func encode<T>(_ value: T) throws -> Self.Output where T : Encodable
}
#endif

extension JSONEncoder: Encoder {
    /// The type this encoder produces.
    public typealias Output = Data
}
