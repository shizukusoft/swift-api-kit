//
//  Foundation.URLRequest+URLRequestable.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation

extension URLRequest: URLRequestable {
    public var requestType: RequestType {
        .data
    }

    public var urlRequest: URLRequest {
        self
    }
}
