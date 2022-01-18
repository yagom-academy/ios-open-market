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
  
  override func setUpWithError() throws {
    sutProductListData = NSDataAsset(name: AssetFileName.products)!.data
    sutProduct = NSDataAsset(name: AssetFileName.Product)!.data
    sutURL = URL(string: "testURL")
    sutSession = MockSession.session
    realSession = URLSession(configuration: .default)
    sutAPIManager = APIManager(urlSession: realSession, jsonParser: JSONParser())
  }
  
  override func tearDownWithError() throws {
    sutProductListData = nil
    sutProduct = nil
    sutURL = nil
    sutSession = nil
    realSession = nil
    sutAPIManager = nil
  }
  
  func test_상품등록() {
    //given
    let expectation = XCTestExpectation(description: "response")
    let image = UIImage(named: "testProduct22")
    guard let image22 = image?.pngData() else {
      XCTFail("이미지 로드 실패")
      return
    }
    let testImageFile = ImageFile(name: "qwe", data: image22, imageType: .png)
    let imageArray: [ImageFile] = [testImageFile]
    let params =  ProductRegistrationRequest(name: "MacBook Pro", descriptions: "Intel MacBook Pro", price: 2690000, currency: .KRW, discountedPrice: 1000000, stock: 99, secret: "password")
    
    sutAPIManager.addProduct(params: params, images: imageArray) { result in
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
    sutAPIManager.modifyProduct(productId: 431, params: modificationProduct) { result in
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
    let secret = Secret(secret: "password")
    sutAPIManager.getDeleteSecret(productId: 431, secret: secret) { result in
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
