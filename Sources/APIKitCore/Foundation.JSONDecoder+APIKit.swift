//
//  Foundation.JSONDecoder+APIKit.swift
//  
//
//  Created by Jaehong Kang on 2022/12/14.
//

import Foundation
import TopLevelCoder

extension JSONDecoder: TopLevelDecoder {
    /// The type this encoder produces.
    public typealias Output = Data
}
