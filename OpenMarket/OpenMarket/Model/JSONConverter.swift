//
//  JSONConverter.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/16.
//

import Foundation

class JSONConverter {
    static func decodeData<T: Codable>(data: Data) -> T? {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            print(error)
            guard let error = error as? DecodingError else { return nil }
            
            switch error {
            case .dataCorrupted:
                print(error)
                return nil
            }
        }
    }
}

enum DecodingError: Error {
    case dataCorrupted
}
