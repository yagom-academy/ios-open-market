//
//  OenMarketAPI.swift
//  OpenMarket
//
//  Created by sole on 2021/01/26.
//

import Foundation
    
    private var decoder = JSONDecoder()
    
    private func decodeData<T>(_ data: Data, type: T.Type) -> T? where T : Decodable {
        let decodedData = try? self.decoder.decode(type, from: data)
        return decodedData
    }
