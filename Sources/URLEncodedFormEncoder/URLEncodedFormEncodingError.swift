//
//  URLEncodedFormEncodingError.swift
//  
//
//  Created by Jaehong Kang on 2022/12/24.
//

import Foundation

public enum URLEncodedFormEncodingError: Error {
    public typealias Context = EncodingError.Context

    case nestedArrayFlatMapError(Context)
}
