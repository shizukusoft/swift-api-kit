//
//  Decoder.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation

#if canImport(Combine)
import Combine

public protocol Decoder<Input>: TopLevelDecoder {
    /// The type this decoder accepts.
    associatedtype Input

    /// Decodes an instance of the indicated type.
    func decode<T>(_ type: T.Type, from: Self.Input) throws -> T where T : Decodable
}
#else
public protocol Decoder<Input> {
    /// The type this decoder accepts.
    associatedtype Input

    /// Decodes an instance of the indicated type.
    func decode<T>(_ type: T.Type, from: Self.Input) throws -> T where T : Decodable
}
#endif

extension JSONDecoder: Decoder {
    /// The type this decoder accepts.
    public typealias Input = Data
}
