//
//  Decodable.swift
//  OpenMarket
//
//  Created by 홍정아 on 2021/08/17.
//

import Foundation

extension Decodable {
    func parse<T: Decodable>(type: T.Type) -> Result<T, Error> {
        let decoder = JSONDecoder()
        if let data = self as? Data,
           let decodedData = try? decoder.decode(type, from: data) {
            return .success(decodedData)
        }
        return .failure(NetworkError.failToDecode)
    }
}
