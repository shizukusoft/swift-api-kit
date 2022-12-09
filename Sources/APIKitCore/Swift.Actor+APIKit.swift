//
//  Swift.Actor+APIKit.swift
//  
//
//  Created by Jaehong Kang on 2022/12/10.
//

import Foundation

extension Actor {
    @inlinable
    public func run<T>(resultType: T.Type = T.self, body: @Sendable (isolated Self) throws -> T) async rethrows -> T where T: Sendable {
        try body(self)
    }

    @_disfavoredOverload
    @inlinable
    public func run<T>(resultType: T.Type = T.self, body: @Sendable (isolated Self) async throws -> T) async rethrows -> T where T: Sendable {
        try await body(self)
    }
}

extension MainActor {
    @_disfavoredOverload
    @inlinable
    public static func run<T>(resultType: T.Type = T.self, body: @MainActor @Sendable () async throws -> T) async rethrows -> T where T: Sendable {
        try await body()
    }
}
