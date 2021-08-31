//
//  Items.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import Foundation

struct GETItems: Decodable {
    let page: Int
    let items: [GETItem]
}
