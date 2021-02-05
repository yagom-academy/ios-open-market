//
//  ItemListModel.swift
//  OpenMarket
//
//  Created by 김지혜 on 2021/02/05.
//

import Foundation

final class ItemListModel {
    static let shared = ItemListModel()
    var data: [Item] = []
    
    private init() {}
}
