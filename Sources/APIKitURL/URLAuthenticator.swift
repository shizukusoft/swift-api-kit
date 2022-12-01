//
//  URLAuthenticator.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation
import APIKitCore

public protocol URLAuthenticator: Authenticator {
    func sign(to urlRequest: inout URLRequest) async throws
}
