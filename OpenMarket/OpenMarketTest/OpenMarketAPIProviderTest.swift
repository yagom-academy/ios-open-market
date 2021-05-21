//
//  OpenMarketAPIProviderTest.swift
//  OpenMarketTest
//
//  Created by 이영우 on 2021/05/21.
//

import XCTest
@testable import OpenMarket

class OpenMarketAPIProviderTest: XCTestCase {
  var openMarketProvider: OpenMarketAPIProvider!
  var expectation: XCTestExpectation!

  override func setUpWithError() throws {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockURLProtocol.self]
    let urlSession = URLSession.init(configuration: configuration)
    
    openMarketProvider = OpenMarketAPIProvider(session: urlSession)
    expectation = XCTestExpectation()
  }
  
  override func tearDownWithError() throws {
    openMarketProvider = nil
    expectation = nil
  }
  
  func test_get_item() {
    MockURLProtocol.requestHandler = { request in
      guard let url = request.url else {
        XCTFail("유효하지 않는 url")
        fatalError()
      }
      
      let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
      
      guard let asset = NSDataAsset(name: "Item") else {
        XCTFail("유효하지 않는파일")
        fatalError()
      }
      let data = asset.data
      
      return (response, data, nil)
    }
    
    openMarketProvider.getData(apiRequestType: .loadProduct(id: 1), completionHandler: { result in
      switch result {
      case .success(let data):
        do {
          let product = try JSONDecoder().decode(ProductSearchResponse.self, from: data)
          XCTAssertEqual(product.title, "MacBook Pro")
        } catch {
          XCTFail()
        }
      case .failure:
        XCTFail()
      }
      self.expectation.fulfill()
    })
    
    wait(for: [expectation], timeout: 5)
  }
}
