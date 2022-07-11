//
//  ProductAPI.swift
//  OpenMarket
//
//  Created by Derrick kim on 2022/07/11.
//

import UIKit

struct ProductAPI<T: Decodable> {
    func fetch(_ fileName: String) -> Result<T, APIError> {
        let jsonDecoder = JSONDecoder()

        do {
            guard let asset = NSDataAsset.init(name: fileName) else {
                return .failure(APIError.jsonFileNotFound)
            }

            let result = try jsonDecoder.decode(T.self, from: asset.data)
            return .success(result)
        } catch {
            return .failure(APIError.failedToDecode)
        }
    }
}
