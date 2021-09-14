//
//  Items.swift
//  OpenMarket
//
//  Created by 이예원 on 2021/09/06.
//

import Foundation

struct Products: Codable {
    var page: Int
    var items: [Product]
}
