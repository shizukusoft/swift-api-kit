//
//  APIURLSession.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation
import APIKitCore

public actor APIURLSession {
    public nonisolated let configuration: Configuration
    public var urlAuthenticator: URLAuthenticator?

    internal nonisolated let urlSession: URLSession
    internal nonisolated let urlSessionDelegate: URLSessionDelegate

    public init(configuration: Configuration) {
        self.configuration = configuration

        let urlSessionDelegate = URLSessionDelegate()

        self.urlSession = URLSession(configuration: configuration.urlSessionConfiguration, delegate: urlSessionDelegate, delegateQueue: nil)
        self.urlSessionDelegate = urlSessionDelegate

        urlSessionDelegate.apiURLSession = self
    }
}

extension APIURLSession: Session {
    public var authenticator: Authenticator? {
        urlAuthenticator
    }
}
