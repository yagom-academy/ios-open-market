//
//  ItemsPageData.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/10.
//

import Foundation

struct ItemsData: Codable {
    let page: Int
    let items: [ItemData]
}
