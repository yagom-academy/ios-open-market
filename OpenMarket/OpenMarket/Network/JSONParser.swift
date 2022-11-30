//
//  JSONParser.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/30.
//

import Foundation

struct JSONParser {
    func decodeJSON<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable  {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        let result = try decoder.decode(type, from: data)
        return result
    }
    
    func encodeJSON<T>(_ value: T) throws -> Data where T : Encodable {
        let encoder = JSONEncoder()
//        encoder.outputFormatting = .utf8
        let result = try encoder.encode(value)
        
        return result
    }

}

