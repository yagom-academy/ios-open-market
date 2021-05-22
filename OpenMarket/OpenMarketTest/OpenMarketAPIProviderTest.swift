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
  
  //MARK: Test Function
  func test_Get_Item_Success() {
    setRequestHandler(shouldSuccess: true)
    openMarketProvider.getData(apiRequestType: .loadProduct(id: 1), completionHandler: { result in
      switch result {
      case .success:
        XCTAssert(true)
      case .failure:
        XCTFail()
      }
      self.expectation.fulfill()
    })
    
    wait(for: [expectation], timeout: 5)
  }
  
  func test_Get_Item_Failure() {
    setRequestHandler(shouldSuccess: false)
    openMarketProvider.getData(apiRequestType: .loadProduct(id: 1), completionHandler: { result in
      switch result {
      case .success:
        XCTFail()
      case .failure:
        XCTAssert(true)
      }
      self.expectation.fulfill()
    })
    
    wait(for: [expectation], timeout: 5)
  }
  
  func test_Post_Item_Success() {
    setRequestHandler(shouldSuccess: true)
    let dummyProduct =
      OpenMarket.ProductRegisterRequest(title: "MacBook Pro", descriptions: "", price: 0,
                                        currency: "", stock: 0, discountedPrice: 0, images: [],
                                        password: "")
    
    openMarketProvider.postProduct(product: dummyProduct,
                                   apiRequestType: .postProduct,
                                   completionHandler: { result in
                                    switch result {
                                    case .success:
                                      XCTAssert(true)
                                    case .failure:
                                      XCTFail()
                                    }
                                    self.expectation.fulfill()
                                   })
    
    wait(for: [expectation], timeout: 5)
  }
  
  func test_Post_Item_Failure() {
    setRequestHandler(shouldSuccess: false)
    let dummyProduct =
      OpenMarket.ProductRegisterRequest(title: "MacBook Pro", descriptions: "", price: 0,
                                        currency: "", stock: 0, discountedPrice: 0, images: [],
                                        password: "")
    
    openMarketProvider.postProduct(product: dummyProduct,
                                   apiRequestType: .postProduct,
                                   completionHandler: { result in
                                    switch result {
                                    case .success:
                                      XCTFail()
                                    case .failure:
                                      XCTAssert(true)
                                    }
                                    self.expectation.fulfill()
                                   })
    
    wait(for: [expectation], timeout: 5)
  }
  
  func test_Update_Item_Success() {
    setRequestHandler(shouldSuccess: true)
    let dummyProduct =
      OpenMarket.ProductUpdateRequest(title: "MacBook Pro", descriptions: "", price: 0,
                                      currency: "", stock: 0, discountedPrice: 0, images: [],
                                      password: "")
    
    openMarketProvider
      .updateProduct(product: dummyProduct,
                     apiRequestType: .patchProduct(id: 1), completionHandler: { result in
                      switch result {
                      case .success:
                        XCTAssert(true)
                      case .failure:
                        XCTFail()
                      }
                      self.expectation.fulfill()
                     })
    
    wait(for: [expectation], timeout: 5)
  }
  
  func test_Update_Item_Failure() {
    setRequestHandler(shouldSuccess: false)
    let dummyProduct =
      OpenMarket.ProductUpdateRequest(title: "MacBook Pro", descriptions: "", price: 0,
                                      currency: "", stock: 0, discountedPrice: 0, images: [],
                                      password: "")
    
    openMarketProvider
      .updateProduct(product: dummyProduct,
                     apiRequestType: .patchProduct(id: 1), completionHandler: { result in
                      switch result {
                      case .success:
                        XCTFail()
                      case .failure:
                        XCTAssert(true)
                      }
                      self.expectation.fulfill()
                     })
    
    wait(for: [expectation], timeout: 5)
  }
  
  func test_Delete_Item_Success() {
    setRequestHandler(shouldSuccess: true)
    let dummyUserInfomation =
      OpenMarket.ProductDeleteRequest(password: "")
    
    openMarketProvider
      .deleteProduct(product: dummyUserInfomation,
                     apiRequestType: .deleteProduct(id: 1), completionHandler: { result in
                      switch result {
                      case .success:
                        XCTAssert(true)
                      case .failure:
                        XCTFail()
                      }
                      self.expectation.fulfill()
                     })
    
    wait(for: [expectation], timeout: 5)
  }
  
  func test_Delete_Item_Failure() {
    setRequestHandler(shouldSuccess: false)
    let dummyUserInfomation =
      OpenMarket.ProductDeleteRequest(password: "")
    
    openMarketProvider
      .deleteProduct(product: dummyUserInfomation,
                     apiRequestType: .deleteProduct(id: 1), completionHandler: { result in
                      switch result {
                      case .success:
                        XCTFail()
                      case .failure:
                        XCTAssert(true)
                      }
                      self.expectation.fulfill()
                     })
    
    wait(for: [expectation], timeout: 5)
  }
  
  //MARK: Set Request Configuration
  private func setRequestHandler(shouldSuccess: Bool) {
    MockURLProtocol.requestHandler = { request in
      guard let url = request.url else {
        XCTFail("유효하지 않는 url")
        fatalError()
      }
      
      let response: HTTPURLResponse?
      if shouldSuccess {
        response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
      } else {
        response = HTTPURLResponse(url: url,
                                       statusCode: 404,
                                       httpVersion: nil,
                                       headerFields: nil)
      }
      
      guard let asset = NSDataAsset(name: "Item") else {
        XCTFail("유효하지 않는파일")
        fatalError()
      }
      let data = asset.data
      
      return (response, data, nil)
    }
  }
  
}
