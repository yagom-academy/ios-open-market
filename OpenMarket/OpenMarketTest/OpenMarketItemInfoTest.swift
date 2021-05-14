//
//  File.swift
//  OpenMarketTest
//
//  Created by 강경 on 2021/05/14.
//

import XCTest
@testable import OpenMarket

class OpenMarketItemInfoTest: XCTestCase {
  func test_list_search_response() {
    guard let marketItem = NSDataAsset(name: "Item") else {
      XCTAssert(false)
      return
    }
    
    do {
      let result = try JSONDecoder().decode(ProductSearchResponse.self, from: marketItem.data)
      XCTAssertEqual(result.price, 1690000)
    } catch {
      XCTAssert(false)
    }
  }
}
