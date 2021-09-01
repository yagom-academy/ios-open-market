//
//  JsonManager.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/31.
//

import UIKit

enum ParsingError: Error, LocalizedError {
    case assetFailed
    case decodingFailed
    case encodingFailed
    
    var errorDescription: String {
        switch self {
        case .assetFailed:
            return "에셋 데이터를 불러오는데 실패했습니다."
        case .decodingFailed:
            return "디코딩에 실패했습니다."
        case .encodingFailed:
            return "인코딩에 실패했습니다."
        }
    }
}

struct ParsingManager {
    private let jsonDecoder = JSONDecoder()
    
    func receivedDataAsset(assetName: String) throws -> NSDataAsset {
        guard let dataAsset = NSDataAsset(name: assetName) else {
            throw ParsingError.assetFailed
        }
        return dataAsset
    }
    
    func decodedJsonData<T: Decodable>(type: T.Type, data: Data) throws -> T {
        guard let decodedData = try? jsonDecoder.decode(type, from: data) else {
            throw ParsingError.decodingFailed
        }
        return decodedData
    }
}
