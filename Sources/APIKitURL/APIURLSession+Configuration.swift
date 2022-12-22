//
//  APIURLSession+Configuration.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation

extension APIURLSession {
    public struct Configuration: Sendable {
        private var _urlSessionConfiguration: URLSessionConfiguration
        public var urlSessionConfiguration: URLSessionConfiguration {
            get {
                _urlSessionConfiguration.copy() as! URLSessionConfiguration
            }
            set {
                _urlSessionConfiguration = newValue.copy() as! URLSessionConfiguration
            }
        }

        public var baseURL: URL?

        public init(
            urlSessionConfiguration: URLSessionConfiguration = .default,
            baseURL: URL? = nil
        ) {
            self._urlSessionConfiguration = urlSessionConfiguration.copy() as! URLSessionConfiguration
            self.baseURL = baseURL
        }
    }
}
