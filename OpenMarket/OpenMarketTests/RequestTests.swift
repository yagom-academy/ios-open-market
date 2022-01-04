//
//  RequestTests.swift
//  OpenMarketTests
//
//  Created by Eunsoo KIM on 2022/01/04.
//

import XCTest

class RequestTests: XCTestCase {

  func test_목록조회() {
    
    let request = RequestOpenMarket()
    var b: ProductList?
    
    let a = request.productList(pageNumber: 1, itemsPerPage: 10) { response in
      switch response {
      case .success(let data):
        b = data
      case .failure(let data):
        print(data)
      }
    }
    sleep(3)
    XCTAssertNotNil(b)
  }
  
  func test_상품상세조회() {
    let request = RequestOpenMarket()
    
    guard let result = request.responseDetailProduct() else {
      return
    }
    
    XCTAssertEqual(result.id, 16)
  }

}
