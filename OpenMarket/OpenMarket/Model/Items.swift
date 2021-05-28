//
//  Items.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/28.
//

import Foundation

struct Items: Decodable {
    let page: Int
    let items: [Item]
}
