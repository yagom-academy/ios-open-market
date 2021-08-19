//
//  Products.swift
//  OpenMarket
//
//  Created by JINHONG AN on 2021/08/10.
//

import Foundation

struct Products: Decodable {
    let page: Int
    let items: [Product]
}
