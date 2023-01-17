//
//  Empty.swift
//  
//
//  Created by Jaehong Kang on 2023/01/17.
//

@frozen
public struct Empty: Equatable, Hashable, Sendable {
    @inlinable
    public init() {

    }
}

extension Empty: Comparable {
    @inlinable
    public static func < (lhs: Empty, rhs: Empty) -> Bool {
        false
    }
}

extension Empty: Decodable {
    @inlinable
    public init(from decoder: Decoder) throws {
        self.init()
    }
}

extension Empty: Encodable {
    @inlinable
    public func encode(to encoder: Encoder) throws {

    }
}

extension Empty: Identifiable {
    @inlinable
    public var id: Empty {
        self
    }
}
