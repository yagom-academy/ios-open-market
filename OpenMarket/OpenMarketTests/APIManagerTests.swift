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
  var sutSession: URLSession!
  var realSession: URLSession!
  var sutAPIManager: APIManager!
  var identifier: String!
  
  override func setUpWithError() throws {
    sutProductListData = NSDataAsset(name: AssetFileName.products)!.data
    sutProduct = NSDataAsset(name: AssetFileName.Product)!.data
    sutURL = URL(string: "testURL")
    sutSession = MockSession.session
    realSession = URLSession(configuration: .default)
    sutAPIManager = APIManager(urlSession: realSession, jsonParser: JSONParser())
    identifier = "3be89f18-7200-11ec-abfa-25c2d8a6d606"
  }
  
  override func tearDownWithError() throws {
    sutProductListData = nil
    sutProduct = nil
    sutURL = nil
    sutSession = nil
    realSession = nil
    sutAPIManager = nil
    identifier = nil
  }
  
  func test_상품등록() {
    //given
    let expectation = XCTestExpectation(description: "response")
    guard let image = UIImage(named: "testProduct22") else {
      return
    }
    let imageArray: [UIImage] = [image]
    let params =  ProductRegistrationRequest(name: "MacBook Pro", descriptions: "Intel MacBook Pro", price: 2690000, currency: .KRW, discountedPrice: 1000000, stock: 99, secret: "-7VPcqeCv=Xbu3&P")
    
    sutAPIManager.registerProduct(params: params, images: imageArray, identifier: identifier) { result in
      // then
      switch result {
      case .success(let data):
        XCTAssertNotNil(data)
      case .failure:
        XCTFail()
      }
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
  }
  
  func test_상품수정() {
    let expectation = XCTestExpectation(description: "response")
    let modificationProduct = ProductModificationRequest(name: "MACBook Ultra Pro", secret: "password")
    sutAPIManager.modifyProduct(productId: 431, params: modificationProduct, identifier: identifier) { result in
      // then
      switch result {
      case .success(let data):
        XCTAssertNotNil(data)
      case .failure:
        XCTFail()
      }
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
  }
  
  func test_상품Secret조회() {
    let expectation = XCTestExpectation(description: "response")
    let secret = "password"
    sutAPIManager.getDeleteSecret(productId: 431, secret: secret, identifier: identifier) { result in
      // then
      switch result {
      case .success(let data):
        dump(data)
        XCTAssertNotNil(data)
      case .failure:
        XCTFail()
      }
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
  }
  
  func test_상품삭제() {
    let expectation = XCTestExpectation(description: "response")
    let productSecret = "827c04d7-7838-11ec-abfa-55347a6e30e7"
    
    sutAPIManager.deleteProduct(productId: 431, productSecret: productSecret, identifier: identifier) { result in
      switch result {
      case .success(let data):
        dump(data)
        XCTAssertNotNil(data)
      case .failure:
        XCTFail()
      }
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10)
  }
  
  func test_목록조회() {
    // given
    let response = HTTPURLResponse(url: sutURL, statusCode: 200, httpVersion: nil, headerFields: nil)
    MockURLProtocol.requestHandler = { request in
      return (response!, self.sutProductListData)
    }
    let expectation = XCTestExpectation(description: "response")
    
    // when
    sutAPIManager.productList(pageNumber: 1, itemsPerPage: 10) { result in
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
    sutAPIManager.detailProduct(productId: 16) { result in
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
