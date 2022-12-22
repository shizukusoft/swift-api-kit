//
//  APIKitCore.swift
//  
//
//  Created by Jaehong Kang on 2022/12/10.
//

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
@_exported import Foundation
#else
@_exported @preconcurrency import Foundation
#endif
@_exported import TopLevelCoder
