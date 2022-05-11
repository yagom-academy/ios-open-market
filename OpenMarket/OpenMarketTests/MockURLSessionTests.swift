//
//  MockURLSessionTests.swift
//  OpenMarketTests
//
//  Created by cathy, mmim.
//

import XCTest
@testable import OpenMarket

final class MockURLSessionTests: XCTestCase {
  var sut: URLSessionProvider<ProductsList>!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = URLSessionProvider<ProductsList>(session: MockURLSession())
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    sut = nil
  }
  
  func test_mockData_pageNumber은_1이다() {
    //given, when
    let data = 1
    //then
    sut.get { result in
      switch result {
      case .success(let products):
        XCTAssertEqual(products.pageNumber, data)
      case .failure(_):
        XCTFail()
      }
    }
  }
  
  func test_mockData_items의개수는_10이다() {
    //given, when
    let data = 10
    //then
    sut.get { result in
      switch result {
      case .success(let products):
        XCTAssertEqual(products.items.count, data)
      case .failure(_):
        XCTFail()
      }
    }
  }
  
  func test_mockData_items의첫번째id는_20이다() {
    //given, when
    let data = 20
    //then
    sut.get { result in
      switch result {
      case .success(let products):
        XCTAssertEqual(products.items.first?.id, data)
      case .failure(_):
        XCTFail()
      }
    }
  }
}
