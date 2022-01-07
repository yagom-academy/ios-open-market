//
//  RequestTests.swift
//  OpenMarketTests
//
//  Created by Eunsoo KIM on 2022/01/04.
//

import XCTest

class APIManagerTests: XCTestCase {
  var sutProductListData = NSDataAsset(name: "products")!.data
  var sutProduct = NSDataAsset(name: "product")!.data
  var sutURL: URL!
  var sutAPIManager: APIManager!
  var sutSession: URLSession!
  
  override func setUpWithError() throws {
    sutURL = URL(string: "testURL")
    sutSession = MockSession.session
    sutAPIManager = APIManager(urlSession: sutSession)
  }
  
  override func tearDownWithError() throws {
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
        dump(data)
        XCTAssertTrue(true)
      case .failure:
        XCTFail()
      }
    }
    sleep(5)

    expectation.fulfill()

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
        dump(data)
        XCTAssertTrue(true)
      case .failure:
        XCTFail()
      }
    }
    

    expectation.fulfill()

    wait(for: [expectation], timeout: 5)
  }
}
