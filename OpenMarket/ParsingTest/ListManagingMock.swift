//
//  ListManagingMock.swift
//  ParsingTest
//
//  Created by 수박, ehd on 2021/08/11.
//

import Foundation
@testable import OpenMarket

class ListManagingMock: ParsingMock {
    typealias Model = ItemList
    
    lazy var data = try? parse(about: "item_list")
    
    func delete(itemNumber: Int) {
        data?.items.remove(at: itemNumber)
    }
}
