//
//  JSONParser.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/13.
//

import Foundation

struct JSONParser {
    func parseJSONDataToValueObject<T: Decodable>(with jsonData: Data) throws -> T {
        let jsonDecoder = JSONDecoder()
        
        do {
            let decodedData = try jsonDecoder.decode(T.self, from: jsonData)
            return decodedData
        } catch {
            throw APIError.JSONParseError
        }
    }
}
