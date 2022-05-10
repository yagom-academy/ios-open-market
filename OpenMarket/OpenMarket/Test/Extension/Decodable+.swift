//
//  Decodable+.swift
//  OpenMarket
//
//  Created by papri, Tiana on 10/05/2022.
//

import UIKit

extension Decodable {
    static func parse(fileName: String) throws -> Self {
        guard let assetFile = NSDataAsset(name: fileName) else {
            throw DecodingError.dataAssetFail
        }
        guard let data = try? JSONDecoder().decode(Self.self, from: assetFile.data) else {
            throw DecodingError.decodeFail
        }
        return data
    }
}
