//
//  MockData.swift
//  OpenMarketTests
//
//  Created by cathy, mmim.
//

import UIKit
@testable import OpenMarket

struct MockData {
  func loadData() -> Data? {
    guard let asset = NSDataAsset(name: "products") else { return nil }
    return asset.data
  }
}
