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
  
    guard let result = JSONParser<ProductList>.decode(data: asset.data) else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(result.pageNumber, 1)
  }
  
  func test_잘못된_제네릭_정보를_설정했을경우_nil을_반환하는지() {
    guard let asset = NSDataAsset.init(name: "products") else {
      XCTFail()
      return
    }
  
    let result = JSONParser<Product>.decode(data: asset.data)
    
    XCTAssertNil(result)
  }

}
