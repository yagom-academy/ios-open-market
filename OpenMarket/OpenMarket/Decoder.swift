//
//  Decoder.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/07.
//

import UIKit

struct Decoder {
    let decoder = JSONDecoder()
    
    func parsePageJSON(data: Data) -> Result<ProductList?, NetworkError> {
        let pageJSON: Data = data
        guard let decodedPageJSON = try? decoder.decode(ProductList.self, from: pageJSON) else {
            return .failure(.parsingFailed)
        }
        return .success(decodedPageJSON)
    }
}
