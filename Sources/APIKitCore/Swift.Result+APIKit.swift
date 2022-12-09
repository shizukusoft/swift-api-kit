//
//  Swift.Result+APIKit.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

extension Result {
    @inlinable
    public func tryMap<NewSuccess>(_ transform: (Success) throws -> NewSuccess) -> Result<NewSuccess, Error> {
        do {
            switch self {
            case let .success(success):
                return try .success(transform(success))
            case let .failure(failure):
                return .failure(failure)
            }
        } catch {
            return .failure(error)
        }
    }
}
