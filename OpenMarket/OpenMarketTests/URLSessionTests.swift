//
//  URLSessionTests.swift
//  OpenMarketTests
//
//  Created by cathy, mmim.
//

import XCTest
@testable import OpenMarket

final class URLSessionTests: XCTestCase {
  private var sut: URLSessionProvider<ProductsList>!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = URLSessionProvider<ProductsList>(session: MockURLSession())
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    sut = nil
  }
  
  private func test_mockData_pageNumber은_1이다() {
    //given, when
    let pageNumber = 1
    //then
    sut.get { result in
      switch result {
      case .success(let products):
        XCTAssertEqual(products.pageNumber, pageNumber)
      case .failure(_):
        XCTFail()
      }
    }
  }
}
