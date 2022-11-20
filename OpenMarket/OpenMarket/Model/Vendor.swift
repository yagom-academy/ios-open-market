//  Vendor.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/15.

import Foundation

struct Vendor: Decodable {
    let ID: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case name
    }
}
