//
//  Decodable+.swift
//  OpenMarket
//
//  Created by 김태현 on 2022/05/10.
//

import UIKit

extension Decodable {
    func parse(fileName: String) throws -> Self {
        guard let assetFile = NSDataAsset(name: fileName) else {
            throw DecodingError.dataAssetFail
        }
        guard let data = try? JSONDecoder().decode(Self.self, from: assetFile.data) else {
            throw DecodingError.decodeFail
        }
        return data
    }
}
