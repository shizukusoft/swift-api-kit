//
//  URLAuthenticator.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

public protocol URLAuthenticator: Authenticator {
    func sign(to urlRequest: inout URLRequest) async throws
}
