//
//  decoderExtension.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/15.
//

import UIKit

extension Decodable {
    func decode<T: Decodable>(asset: String) -> T? {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let asset = NSDataAsset(name: asset) else { return nil }
        
        do {
            let data: T = try decoder.decode(T.self, from: asset.data)
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
