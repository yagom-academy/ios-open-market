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
        } catch DecodingError.keyNotFound(let key, let context) {
            print("could not find key \(key) in JSON: \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            print("could not find type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            print("data found to be corrupted in JSON: \(context.debugDescription)")
        } catch let error as NSError {
            NSLog("Error in decode(_:from:) domain: \(error.domain), description: \(error.localizedDescription)")
        }
        return decodedData
    }
}
