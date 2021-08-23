//
//  ItemListPage.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/08/12.
//

import Foundation

class ItemBundle: Decodable {
    let page: Int
    let items: [Item]
}
