//
//  ItemListSearchTest.swift
//  OpenMarketTest
//
//  Created by 이영우 on 2021/05/14.
//

import XCTest
@testable import OpenMarket

class ItemListSearchTest: XCTestCase {
  var listSearcher: MockItemListSearcher!
  
  override func setUpWithError() throws {
    listSearcher = MockItemListSearcher()
  }
  
  override func tearDownWithError() throws {
    listSearcher = nil
  }
  
  func test_MocklistFile_3번째_item확인() {
    let expectation = XCTestExpectation(description: "network connect")
    var result: ListSearchResponse?
    
    listSearcher.search(page: 1, completionHandler: { list in
      result = list
      expectation.fulfill()
    })
    
    wait(for: [expectation], timeout: 5)
    guard let result = result else {
      XCTFail()
      return
    }
    XCTAssertEqual(result.items[2].id, 3)
    XCTAssertEqual(result.items[2].price, 890000)
  }
}
