//
//  Items.swift
//  OpenMarket
//
//  Created by 김동빈 on 2021/01/27.
//

import Foundation

struct Items: Codable {
    let page: Int
    var items: [Item]
}
