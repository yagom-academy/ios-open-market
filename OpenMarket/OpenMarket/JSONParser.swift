//
//  JSONParser.swift
//  OpenMarket
//
//  Created by Dasoll Park on 2021/08/13.
//

import Foundation

struct JSONParser {
    let decoder = JSONDecoder()
    
    func parse<T: Decodable>(type: T.Type, data: Data) -> Result<T, Error> {
        if let decodedData = try? decoder.decode(type, from: data) {
            return .success(decodedData)
        }
        return .failure(NetworkError.failToDecode)
    }
}
