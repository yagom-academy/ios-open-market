//
//  Encoder.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/26.
//

import Foundation

struct Encoder {
    func encodeToJSON(data: ProductParams) -> Result<Data, NetworkError> {
        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(data) else {
            return .failure(.parsingFailed)
        }
        
        return .success(data)
    }
}
