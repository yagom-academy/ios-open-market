//
//  ProductDecoder.swift

//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/12.
//

import Foundation

enum ParsingError: Error {
    case failedDecoding
    case failedEncoding
}

struct DataDecoder {
    func decode<T: Decodable>(type: T.Type, data: Data) throws -> T {
        let jsonDecoder = JSONDecoder()
        
        do {
            let decodedData =  try jsonDecoder.decode(T.self, from: data)
            return decodedData
        } catch {
            throw ParsingError.failedDecoding
        }
    }
}
