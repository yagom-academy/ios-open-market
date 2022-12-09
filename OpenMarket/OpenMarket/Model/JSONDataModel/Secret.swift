//
//  Secret.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/12/02.
//

struct Secret: Encodable {
    let secretKey: String
    
    private enum CodingKeys: String, CodingKey {
        case secretKey = "secret"
    }
}
