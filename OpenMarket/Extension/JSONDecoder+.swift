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
        } catch {
            print(error.localizedDescription)
        }
        return decodedData
    }
}
