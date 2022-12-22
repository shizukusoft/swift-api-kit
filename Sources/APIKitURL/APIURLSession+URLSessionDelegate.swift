//
//  APIURLSession+URLSessionDelegate.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

extension APIURLSession {
    class URLSessionDelegate: NSObject {
        weak var apiURLSession: APIURLSession?
    }
}

extension APIURLSession.URLSessionDelegate: URLSessionDelegate {

}

extension APIURLSession.URLSessionDelegate: URLSessionTaskDelegate {

}
