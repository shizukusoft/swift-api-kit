//
//  APIURLSession.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation
import APIKitCore

public actor APIURLSession {
    public nonisolated let urlSession: URLSession
    let urlSessionDelegate: URLSessionDelegate
    public var urlAuthenticator: URLAuthenticator?

    public init(configuration: Configuration) {
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
