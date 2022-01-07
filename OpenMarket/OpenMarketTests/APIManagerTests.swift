//
//  RequestTests.swift
//  OpenMarketTests
//
//  Created by Eunsoo KIM on 2022/01/04.
//

import XCTest

class APIManagerTests: XCTestCase {
  var sutProductListData: Data!
  var sutProduct: Data!
  var sutURL: URL!
  var sutAPIManager: APIManager!
  var sutSession: URLSession!
  
  override func setUpWithError() throws {
    sutProductListData = NSDataAsset(name: "products")!.data
    sutProduct = NSDataAsset(name: "product")!.data
    sutURL = URL(string: "testURL")
    sutSession = MockSession.session
    sutAPIManager = APIManager(urlSession: sutSession)
  }
  
  override func tearDownWithError() throws {
    sutProductListData = nil
    sutProduct = nil
    sutURL = nil
    sutSession = nil
    sutAPIManager = nil
  }
  
  func test_목록조회() {
    // given
    let response = HTTPURLResponse(url: sutURL, statusCode: 200, httpVersion: nil, headerFields: nil)
    MockURLProtocol.requestHandler = { request in
      return (response!, self.sutProductListData)
    }
    let expectation = XCTestExpectation(description: "response")
    
    // when
    sutAPIManager!.productList(pageNumber: 1, itemsPerPage: 10) { result in
      // then
      switch result {
      case .success(let data):
        XCTAssertEqual(5, data.pages.count)
        XCTAssertEqual(1, data.pageNumber)
      case .failure:
        XCTFail()
      }
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 5)
  }
  
  
  func test_상품상세조회() {
    // given
    let response = HTTPURLResponse(url: sutURL, statusCode: 200, httpVersion: nil, headerFields: nil)
    MockURLProtocol.requestHandler = { request in
      return (response!, self.sutProduct)
    }
    let expectation = XCTestExpectation(description: "response")
    
    // when
    sutAPIManager!.detailProduct(productId: 16) { result in
      // then
      switch result {
      case .success(let data):
        XCTAssertEqual("pizza", data.name)
        XCTAssertEqual(25000, data.price)
      case .failure:
        XCTFail()
      }
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 5)
  }
}
