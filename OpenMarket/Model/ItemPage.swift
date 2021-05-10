//
//  ItemPage.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/10.
//

import Foundation

struct ItemPage: Decodable  {
    var page: Int
    var items: [Item]
}


