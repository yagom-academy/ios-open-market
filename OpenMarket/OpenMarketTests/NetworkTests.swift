//
//  NetworkTests.swift
//  OpenMarketTests
//
//  Created by Eunsoo KIM on 2022/01/19.
//

import XCTest

@testable import OpenMarket
class NetworkTests: XCTestCase {
  
  let networkManager = NetworkManager()
  
  func test_목록조회가_잘되는지() {
    
    let expectation = XCTestExpectation(description: "response")
    
    networkManager.getItemList(pageNo: 1, itmesPerPage: 10) { result in
      switch result {
      case .success(let itemList):
        expectation.fulfill()
        XCTAssertEqual(itemList.items.count, 10)
      case .failure(let error):
        print(error)
        XCTFail()
      }
    }
    wait(for: [expectation], timeout: 5)
  }

  func test_상품상세정보조회가_잘되는지() {
    
    let expectation = XCTestExpectation(description: "response")
    
    networkManager.getItemInfo(itemId: 223) { result in
      switch result {
      case .success(let itemInfo):
        expectation.fulfill()
        XCTAssertEqual(itemInfo.id, 223)
      case .failure(let error):
        print(error)
        XCTFail()
      }
    }
    wait(for: [expectation], timeout: 5)
  }


  

}
