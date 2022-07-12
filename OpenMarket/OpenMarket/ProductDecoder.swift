//
//  ProductDecoder.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/12.
//

import Foundation

func decodeMarket<T: Codable>(type: T.Type, data: Data) -> T? {
    let jsonDecoder = JSONDecoder()
    
    do {
       let decodedData =  try jsonDecoder.decode(T.self, from: data)
        return decodedData
    } catch {
        print("Unexpected error: \(error)")
    }
    
    return nil
}
