//
//  RequestTests.swift
//  OpenMarketTests
//
//  Created by Eunsoo KIM on 2022/01/04.
//

import XCTest

class APIManagerTests: XCTestCase {

  func test_목록조회() {
    let apiManager = APIManager()
    let itemList = apiManager.productList(pageNumber: 1, itemsPerPage: 10)
    
    guard let result = itemList else {
      XCTFail()
      return
    }
    
    XCTAssertNotNil(result)
  }
  
  func test_상품상세조회() {
    let apiManager = APIManager()
    let detailInfo = apiManager.DetailProduct(productId: 16)
    
    guard let result = detailInfo else {
      XCTFail()
      return
    }

    XCTAssertEqual(result.id, 16)
  }

}
