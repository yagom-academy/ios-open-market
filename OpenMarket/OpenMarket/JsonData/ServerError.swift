//
//  ServerError.swift
//  OpenMarket
//
//  Created by 임성민 on 2021/01/26.
//

import Foundation

struct ServerError: Decodable {
    let occurrence: Bool
    let reason: String
    
    enum CodingKeys: String, CodingKey {
        case occurrence = "error"
        case reason
    }
}
