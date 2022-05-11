//
//  ProductsTests.swift
//  OpenMarketTests
//
//  Created by cathy, mmim.
//

import XCTest
@testable import OpenMarket

final class OpenMarketTests: XCTestCase {
  var sut: ProductsList!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    let asset = NSDataAsset(name: "products")!
    self.sut = try? JSONDecoder().decode(ProductsList.self, from: asset.data)
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    self.sut = nil
  }
  
  func testDecode_Jsonfile_pageNo이_1이다() {
    //given
    let pageNumber = 1
    //when
    let result = sut.pageNumber
    //then
    XCTAssertEqual(pageNumber, result)
  }
  
  func testDecode_Jsonfile_pages수는_10이다() {
    //given
    let numberOfItems = 10
    //when
    let result = sut.items.count
    //then
    XCTAssertEqual(numberOfItems, result)
  }
  
  func testDecode_Jsonfile_pages의첫번째Id는_20이다() {
    //given
    let productId = 20
    //when
    let result = sut.items[0].id
    //then
    XCTAssertEqual(productId, result)
  }
}
