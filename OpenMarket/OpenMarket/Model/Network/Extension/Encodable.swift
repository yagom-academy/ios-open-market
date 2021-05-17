//
//  Encodable.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/05/17.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            print(APIError.encodingFailure)
            return nil
        }
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            print(APIError.dictionaryConversionFailure)
            return nil
        }
        
        return dictionary
    }
}
