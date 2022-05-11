//
//  URLSessionTests.swift
//  OpenMarketTests
//
//  Created by cathy, mmim.
//

import XCTest
@testable import OpenMarket

class URLSessionTests: XCTestCase {
  var sut: URLSessionProvider<ProductsList>!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = URLSessionProvider<ProductsList>(path: "/api/products", parameters: ["page_no": "1", "items_per_page": "20"])
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    sut = nil
  }
  
  func test_해당api경로의_totalCount는_1368이다() {
    //given
    let promise = expectation(description: "")
    let data = 1368
    //when
    sut.get { result in
      //then
      switch result {
      case .success(let products):
        XCTAssertEqual(products.totalCount, data)
      case .failure(_):
        XCTFail()
      }
      promise.fulfill()
    }
    wait(for: [promise], timeout: 10)
  }
  
  func test_해당api경로의_첫번째page의name은_123123이다() {
    //given
    let promise = expectation(description: "")
    let data = "123123"
    //when
    sut.get { result in
      //then
      switch result {
      case .success(let products):
        XCTAssertEqual(products.items.first?.name, data)
      case .failure(_):
        XCTFail()
      }
      promise.fulfill()
    }
    wait(for: [promise], timeout: 10)
  }
}
