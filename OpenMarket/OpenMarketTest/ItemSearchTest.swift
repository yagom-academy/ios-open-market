//
//  ItemSearchTest.swift
//  OpenMarketTest
//
//  Created by 이영우 on 2021/05/14.
//

import XCTest
@testable import OpenMarket

class ItemSearchTest: XCTestCase {
  var itemSearcher: MockItemSearcher!
  
  override func setUpWithError() throws {
    itemSearcher = MockItemSearcher()
  }
  
  override func tearDownWithError() throws {
    itemSearcher = nil
  }
  
  func test_첫번째_아이템_조회() {
    let expectation = XCTestExpectation(description: "network connect")
    var result: ProductSearchResponse?

    itemSearcher.search(id: 50, completionHandler: { product in
      result = product
      expectation.fulfill()
    })

    wait(for: [expectation], timeout: 5)
    guard let result = result else {
      XCTFail()
      return
    }
    XCTAssertEqual(result.id, 1)
    XCTAssertEqual(result.price, 1690000)
  }
}
