//
//  URLEncodedFormFuture.swift
//  
//
//  Created by Jaehong Kang on 2022/12/14.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

enum URLEncodedFormFuture {
    case string(String)
    case encoder(URLEncodedFormEncoder._Encoder)
    case nestedArray(RefArray)
    case nestedDictionary(RefDictionary)
}

extension URLEncodedFormFuture {
    @dynamicMemberLookup
    final class RefArray: ExpressibleByArrayLiteral {
        var array: [URLEncodedFormFuture]

        init(_ array: [URLEncodedFormFuture]) {
            self.array = array
        }

        convenience init(arrayLiteral elements: URLEncodedFormFuture...) {
            self.init(elements)
        }

        subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<[URLEncodedFormFuture], T>) -> T {
            array[keyPath: keyPath]
        }
    }

    @dynamicMemberLookup
    final class RefDictionary: ExpressibleByDictionaryLiteral {
        var dictionary: [String: URLEncodedFormFuture]

        init(_ dictionary: [String: URLEncodedFormFuture]) {
            self.dictionary = dictionary
        }

        convenience init(dictionaryLiteral elements: (String, URLEncodedFormFuture)...) {
            self.init(Dictionary(uniqueKeysWithValues: elements))
        }

        subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<[String: URLEncodedFormFuture], T>) -> T {
            dictionary[keyPath: keyPath]
        }
    }
}

extension URLEncodedFormFuture {
    func urlQueryItems(options: URLEncodedFormEncoder._Options) throws -> [URLQueryItem] {
        try urlQueryItems(keySpace: "", options: options)
    }

    private func urlQueryItems(keySpace: String, options: URLEncodedFormEncoder._Options) throws -> [URLQueryItem] {
        switch self {
        case .string(let string):
            if !keySpace.isEmpty {
                return [URLQueryItem(name: keySpace, value: string)]
            } else {
                return [URLQueryItem(name: string, value: nil)]
            }
        case .encoder(let encoder):
            return try encoder.future?.urlQueryItems(keySpace: keySpace, options: options) ?? []
        case .nestedArray(let refArray):
            let urlQueryItems = try refArray.array.enumerated().flatMap { (index, value) in
                try value.urlQueryItems(keySpace: keySpace + options.arrayEncodingStrategy(index), options: options)
            }

            switch options.arrayEncodingStrategy {
            case .commaSeparated:
                return [
                    URLQueryItem(
                        name: keySpace,
                        value: try urlQueryItems.lazy
                            .compactMap {
                                guard $0.name == keySpace else {
                                    throw URLEncodedFormEncodingError.nestedArrayFlatMapError(.init(codingPath: [], debugDescription: "Nested value on array not allowed when using commaSeparated option: \(keySpace)"))
                                }

                                return $0.value
                            }
                            .joined(separator: ",")
                    )
                ]
            case .brackets(_), .custom(_), .none, .notAllowed:
                return urlQueryItems
            }
        case .nestedDictionary(let refDictionary):
            return try refDictionary.dictionary.flatMap { (key, value) in
                if keySpace.isEmpty {
                    return try value.urlQueryItems(keySpace: key, options: options)
                } else {
                    return try value.urlQueryItems(keySpace: keySpace + "[\(key)]", options: options)
                }
            }
        }
    }
}
