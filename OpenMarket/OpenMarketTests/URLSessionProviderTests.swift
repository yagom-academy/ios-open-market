//
//  URLSessionProviderTests.swift
//  OpenMarketTests
//
//  Created by cathy, mmim.
//

import XCTest
@testable import OpenMarket

class URLSessionProviderTests: XCTestCase {
  var sutProductsList: URLSessionProvider<ProductsList>!
  var sutItem: URLSessionProvider<Item>!
  var sutHealthyChecker: URLSessionProvider<String>!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
  }
  
  func test_healthChecker_api_경로를_통한_통신이_되는지() {
    //given
    let promise = expectation(description: "")
    sutHealthyChecker = URLSessionProvider<String>(path: "/healthChecker")
    let data = "OK"
    //when
    sutHealthyChecker.get { result in
      //then
      switch result {
      case .success(let products):
        XCTAssertEqual(products, data)
      case .failure(_):
        XCTFail()
      }
      promise.fulfill()
    }
    wait(for: [promise], timeout: 10)
  }
  
  func test_productsList_api경로의_totalCount는_1368이다() {
    //given
    let promise = expectation(description: "")
    sutProductsList = URLSessionProvider<ProductsList>(path: "/api/products",
                                           parameters: ["page_no": "1", "items_per_page": "20"])
    let data = 1367
    //when
    sutProductsList.get { result in
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
  
  func test_productsList_api경로의_첫번째page의_name은_123123이다() {
    //given
    let promise = expectation(description: "")
    sutProductsList = URLSessionProvider<ProductsList>(path: "/api/products",
                                           parameters: ["page_no": "1", "items_per_page": "20"])
    let data = "123123"
    //when
    sutProductsList.get { result in
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
  
  func test_productsDetail_api경로의_id_2071의_이름은_포스트_이다() {
    //given
    let promise = expectation(description: "")
    sutItem = URLSessionProvider<Item>(path: "/api/products/2071")
    let data = "포스트"
    //when
    sutItem.get { result in
      //then
      switch result {
      case .success(let product):
        XCTAssertEqual(product.name, data)
      case .failure(_):
        XCTFail()
      }
      promise.fulfill()
    }
    wait(for: [promise], timeout: 10)
  }
}
