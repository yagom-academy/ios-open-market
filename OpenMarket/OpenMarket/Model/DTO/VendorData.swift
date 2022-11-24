//
//  VendorData.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import Foundation

struct VendorData: Decodable, Hashable {
    let identifier: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
    }
}
