//
//  DecodeManager.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/14.
//

import UIKit

struct DecodeManager<T: Decodable> {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func decodeJsonFile(file: String) -> Result<T, NetworkError> {
        guard let assetData: NSDataAsset = NSDataAsset.init(name: file) else {
            return Result.failure(NetworkError.empty)
        }
        
        guard let datas = try? decoder.decode(T.self, from: assetData.data) else {
            return Result.failure(NetworkError.decoding)
        }

        return Result.success(datas)
    }
    
    func decodeData(data: Data) -> Result<T, NetworkError> {
        guard let datas = try? decoder.decode(T.self, from: data) else {
            return Result.failure(NetworkError.decoding)
        }
        
        return Result.success(datas)
    }
}
