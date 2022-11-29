//
//  JSONDecoder+.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import UIKit

extension JSONDecoder {
    static func decode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        let decoder: JSONDecoder = JSONDecoder()
        
        var decodedData: T?
        do {
            decodedData = try decoder.decode(type, from: data)
        } catch let error as DecodingError {
            print(error.errorDescription)
        } catch {
            print(error.localizedDescription)
        }
        return decodedData
    }
}

extension JSONEncoder {
    static func encode<T: Encodable>(from object: T) -> Data? {
        let encoder: JSONEncoder = JSONEncoder()
        
        var encodedData: Data?
        do {
            encodedData = try encoder.encode(object)
        } catch let error as EncodingError {
            print(error.errorDescription ?? error.localizedDescription)
        } catch {
            print(error.localizedDescription)
        }
        return encodedData
    }
}
