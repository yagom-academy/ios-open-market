//
//  MockURL.swift
//  OpenMarketTests
//
//  Created by 홍정아 on 2021/08/13.
//

import UIKit

enum MockURL: String, CustomStringConvertible {
    case mockItems = "Items"
    case mockItem = "Item"
    
    var description: String {
        self.rawValue
    }
    
    static func obtainData(of url: URL) -> Data? {
        let fileName = url.absoluteString
        return NSDataAsset(name: fileName)?.data
    }
}
