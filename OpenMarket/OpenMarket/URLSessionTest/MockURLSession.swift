//
//  MockURLSession.swift
//  URLSessionTest
//
//  Created by song on 2022/05/12.
//

import UIKit
@testable import OpenMarket

struct MockData {
    func load() -> Data? {
        guard let asset = NSDataAsset(name: "products") else {
            return nil
        }
        return asset.data
    }
}
