//
//  Session.swift
//  
//
//  Created by Jaehong Kang on 2022/12/10.
//

public protocol Session: Actor {
    var authenticator: Authenticator? { get }
}
