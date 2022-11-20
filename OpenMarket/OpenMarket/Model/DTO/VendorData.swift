//
//  VendorData.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import Foundation

struct VendorData: Decodable {
    let identifier: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
    }
}
