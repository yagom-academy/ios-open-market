//
//  ApiProviderTests.swift
//  OpenMarketTests
//
//  Created by cathy, mmim.
//

import XCTest
@testable import OpenMarket

class ApiProviderTests: XCTestCase {
  var sut: ApiProvider!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = ApiProvider()
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
  }
  
  func test_healthChecker_api_경로를_통한_통신이된다() {
    //given
    let promise = expectation(description: "")
    let data = "OK"
    //when
    sut.get(.healthChecker) { result in
      //then
      switch result {
      case .success(let result):
        guard let products = try? JSONDecoder().decode(String.self, from: result) else {
          return
        }
        XCTAssertEqual(products, data)
      case .failure(_):
        XCTFail()
      }
      promise.fulfill()
    }
    wait(for: [promise], timeout: 10)
  }
}
