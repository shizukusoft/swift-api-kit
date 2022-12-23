//
//  APIURLSession.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

public actor APIURLSession {
    public nonisolated let configuration: Configuration
    public var urlAuthenticator: URLAuthenticator?

    internal nonisolated let urlSession: URLSession
    internal nonisolated let urlSessionDelegate: URLSessionDelegate

    public init(configuration: Configuration, urlAuthenticator: URLAuthenticator? = nil) {
        self.configuration = configuration
        self.urlAuthenticator = urlAuthenticator

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
