//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Kim Do hyung on 2021/08/10.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
  
  let decoder = JSONDecoder()
  var product: Product?
  
  override func setUp() {
    super.setUp()
  }
 
  func test_items_Json파일을_decoder했을때_title이_맥북프로이다() {
    //given
    guard let assetData = NSDataAsset.init(name: "item") else { return }
    //when
    let productData = try? decoder.decode(Product.self, from: assetData.data)
    let result = productData?.title
    let expectedResult = "MacBook Pro1123123"
    //then
    XCTAssertEqual(result, expectedResult)
    XCTAssertNil(expectedResult)
  }
}
