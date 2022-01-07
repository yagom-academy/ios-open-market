//
//  JSONTests.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/04.
//

import XCTest
@testable import OpenMarket

class JSONTests: XCTestCase {

  func test_JSON파일이_파싱이_되는지() {
    guard let asset = NSDataAsset.init(name: "products") else {
      XCTFail()
      return
    }
  
    let result = JSONParser<ProductList>.decode(data: asset.data)
    switch result {
    case .success(let data):
      XCTAssertNotNil(data)
    case .failure(_):
      XCTFail()
    }
  
  }
  
  func test_잘못된_제네릭_정보를_설정했을경우_fail을_반환하는지() {
    guard let asset = NSDataAsset.init(name: "products") else {
      XCTFail()
      return
    }
  
    let result = JSONParser<Product>.decode(data: asset.data)
    switch result {
    case .success(_):
      XCTFail()
    case .failure(_):
      XCTAssertTrue(true)
    }
  
  }

}
