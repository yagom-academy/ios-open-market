//
//  JSONParser.swift
//  OpenMarket
//
//  Created by Dasoll Park on 2021/08/13.
//

import Foundation

struct JSONParser {
    let decoder = JSONDecoder()
    
    func parse<T: Decodable>(type: T.Type, data: Data) throws -> T {
        return try decoder.decode(type, from: data)
    }
}
