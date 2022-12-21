//
//  APIURLSession+Configuration.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation

extension APIURLSession {
    public struct Configuration: Sendable {
        public var urlSessionConfiguration: URLSessionConfiguration
        public var baseURL: URL?

        public init(
            urlSessionConfiguration: URLSessionConfiguration = .default,
            baseURL: URL? = nil
        ) {
            self.urlSessionConfiguration = urlSessionConfiguration
            self.baseURL = baseURL
        }
    }
}
