//
//  URLSessionProviderTests.swift
//  OpenMarketTests
//
//  Created by cathy, mmim.
//

import XCTest
@testable import OpenMarket

class URLSessionProviderTests: XCTestCase {
  var sut: URLSessionProvider<ProductsList>!
  var sutHealthyChecker: URLSessionProvider<String>!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
  }
  
  func test_healthChecker_api_경로를_통한_통신이된다() {
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
    sut = URLSessionProvider<ProductsList>(path: "/api/products",
                                           parameters: ["page_no": "1", "items_per_page": "20"])
    let data = 1367
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
  
  func test_productsList_items_per_page_30으로_조회하면_itemsPerPage가_30_이다() {
    //given
    let promise = expectation(description: "")
    sut = URLSessionProvider<ProductsList>(path: "/api/products",
                                           parameters: ["page_no": "1", "items_per_page": "30"])
    let data = 30
    //when
    sut.get { result in
      //then
      switch result {
      case .success(let products):
        XCTAssertEqual(products.itemsPerPage, data)
      case .failure(_):
        XCTFail()
      }
      promise.fulfill()
    }
    wait(for: [promise], timeout: 10)
  }
  
  func test_productsList_items_per_page_30으로_조회하면_limit가_40_이다() {
    //given
    let promise = expectation(description: "")
    sut = URLSessionProvider<ProductsList>(path: "/api/products",
                                           parameters: ["page_no": "1", "items_per_page": "40"])
    let data = 40
    //when
    sut.get { result in
      //then
      switch result {
      case .success(let products):
        XCTAssertEqual(products.limit, data)
      case .failure(_):
        XCTFail()
      }
      promise.fulfill()
    }
    wait(for: [promise], timeout: 10)
  }
  
  func test_productsList_parameters_1_20으로_조회하면_lastPage는_69_이다() {
    //given
    let promise = expectation(description: "")
    sut = URLSessionProvider<ProductsList>(path: "/api/products",
                                           parameters: ["page_no": "1", "items_per_page": "20"])
    let data = 69
    //when
    sut.get { result in
      //then
      switch result {
      case .success(let products):
        XCTAssertEqual(products.lastPage, data)
      case .failure(_):
        XCTFail()
      }
      promise.fulfill()
    }
    wait(for: [promise], timeout: 10)
  }
  
  func test_productsList_parameters_69_20_으로_조회하면_hasNext는_false_이다() {
    //given
    let promise = expectation(description: "")
    sut = URLSessionProvider<ProductsList>(path: "/api/products",
                                           parameters: ["page_no": "69", "items_per_page": "20"])
    //when
    sut.get { result in
      //then
      switch result {
      case .success(let products):
        XCTAssertFalse(products.hasNext!)
      case .failure(_):
        XCTFail()
      }
      promise.fulfill()
    }
    wait(for: [promise], timeout: 10)
  }
  
  func test_productsDetail_api경로의_첫번째page의_name은_123123이다() {
    //given
    let promise = expectation(description: "")
    sut = URLSessionProvider<ProductsList>(path: "/api/products")
    let data = "123123"
    //when
    sut.get { result in
      //then
      switch result {
      case .success(let product):
        XCTAssertEqual(product.items[0].name, data)
      case .failure(_):
        XCTFail()
      }
      promise.fulfill()
    }
    wait(for: [promise], timeout: 10)
  }
  
  func test_productsDetail_api경로의_이다() {
    //given
    let promise = expectation(description: "")
    sut = URLSessionProvider<ProductsList>(path: "/api/products")
    let data = "2022-05-09T00:00:00.00"
    //when
    sut.get { result in
      //then
      switch result {
      case .success(let product):
        XCTAssertEqual(product.items[0].createdAt, data)
      case .failure(_):
        XCTFail()
      }
      promise.fulfill()
    }
    wait(for: [promise], timeout: 10)
  }
}
