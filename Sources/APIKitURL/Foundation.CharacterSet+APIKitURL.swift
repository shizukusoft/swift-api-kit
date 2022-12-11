//
//  Foundation.CharacterSet+APIKitCore.swift
//  
//
//  Created by Jaehong Kang on 2022/12/11.
//

import Foundation

extension CharacterSet {
    public static var asciiUppercaseLetters: Self {
        CharacterSet(charactersIn: "A"..."Z")
    }
    public static var asciiLowercaseLetters: Self {
        CharacterSet(charactersIn: "a"..."z")
    }
    public static var asciiDigits: Self {
        CharacterSet(charactersIn: "0"..."9")
    }

    public static var rfc3986Unreserved: Self {
        asciiUppercaseLetters
            .union(asciiLowercaseLetters)
            .union(asciiDigits)
            .union(["-", ".", "_", "~"])
    }
}
