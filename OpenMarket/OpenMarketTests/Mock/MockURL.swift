//
//  MockURL.swift
//  OpenMarketTests
//
//  Created by 홍정아 on 2021/08/13.
//

import UIKit
@testable import OpenMarket

enum MockURL: String, CustomStringConvertible {
    case mockItems = "https://camp-open-market-2.herokuapp.com/items/1"
    case mockItem = "https://camp-open-market-2.herokuapp.com/item/1"
    
    var description: String {
        self.rawValue
    }
    
    static func obtainData(of url: URL) -> Data? {
        switch url {
        case URL(string: MockURL.mockItems.description):
            return NSDataAsset(name: "Items")?.data
        case URL(string: MockURL.mockItem.description):
            return NSDataAsset(name: "Item")?.data
        default:
            return nil
        }
    }
}
