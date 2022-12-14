//
//  URLEncodedFormEncoder+Options.swift
//  
//
//  Created by Jaehong Kang on 2022/12/14.
//

extension URLEncodedFormEncoder {
    struct _Options {
        let boolEncodingStrategy: BoolEncodingStrategy
        let nilEncodingStrategy: NilEncodingStrategy
        let arrayEncodingStrategy: ArrayEncodingStrategy
        let dictionaryEncodingStrategy: DictionaryEncodingStrategy
        let userInfo: [CodingUserInfoKey: Any]
    }

    var options: _Options {
        .init(
            boolEncodingStrategy: boolEncodingStrategy,
            nilEncodingStrategy: nilEncodingStrategy,
            arrayEncodingStrategy: arrayEncodingStrategy,
            dictionaryEncodingStrategy: dictionaryEncodingStrategy,
            userInfo: userInfo
        )
    }
}
