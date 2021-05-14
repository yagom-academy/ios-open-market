//
//  OpenMarketItemListTest.swift
//  OpenMarketTest
//
//  Created by 강경 on 2021/05/14.
//

import XCTest
@testable import OpenMarket

class OpenMarketItemListTest: XCTestCase {
  func test_list_search_response() {
    guard let marketItems = NSDataAsset(name: "Items") else {
      XCTAssert(false)
      return
    }
    
    do {
      let result = try JSONDecoder().decode(ListSearchResponse.self, from: marketItems.data)
      XCTAssertEqual(result.items[0].title, "MacBook Pro")
    } catch {
      XCTAssert(false)
    }
  }
}
