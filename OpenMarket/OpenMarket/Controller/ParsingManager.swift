//
//  ParsingManager.swift
//  OpenMarket
//
//  Created by Yongwoo Marco on 2021/08/19.
//

import Foundation

struct ParsingManager {
    private enum ParsingError: Error {
        case failDecoding
    }
    
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func parse<T: Decodable>(_ data: Data, to type: T.Type) -> Result<T, Error> {
        do {
            let result = try decoder.decode(type, from: data)
            return .success(result)
        } catch {
            return .failure(ParsingError.failDecoding)
        }
    }
}
