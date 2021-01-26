//
//  Coding.swift
//  OpenMarket
//
//  Created by sole on 2021/01/26.
//

import Foundation

struct Parser {

    static func decodeData<T: Decodable>(_ type: T.Type, _ data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(type, from: data)
            return response
        } catch let error {
            print("decoding error: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func encodeData<T: Encodable>(_ value: T) -> Data? {
        let encorder = JSONEncoder()
        do {
            let jsonData = try encorder.encode(value)
            return jsonData
        } catch let error {
            print("encoding error: \(error.localizedDescription)")
            return nil
        }
    }
}
