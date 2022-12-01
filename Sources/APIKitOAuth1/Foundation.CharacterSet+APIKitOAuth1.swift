//
//  Foundation.CharacterSet+APIKitOAuth1.swift
//  
//
//  Created by Jaehong Kang on 2022/12/01.
//

import Foundation

extension CharacterSet {
    static let rfc3986Allowed: CharacterSet = {
        let digits = CharacterSet(charactersIn: "0123456789")
        let uppercaseLetters = CharacterSet(charactersIn: "ABCDEFGHJIKLMNOPQRSTUVWXYZ")
        let lowercaseLetters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
        let reservedCharacters = CharacterSet(charactersIn: "-._~")

        return digits.union(uppercaseLetters).union(lowercaseLetters).union(reservedCharacters)
    }()
}
