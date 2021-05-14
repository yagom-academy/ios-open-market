//
//  MockItemSearcher.swift
//  OpenMarketTest
//
//  Created by 이영우 on 2021/05/14.
//

import XCTest
import Foundation
@testable import OpenMarket

class MockItemSearcher {
  var shouldReturnError = false
  var searchWasCalled = false
  var sut_item: ProductSearchResponse? = nil
  
  init() {
    guard let itemAsset = NSDataAsset.init(name: "Item") else {
      XCTFail()
      return
    }
    do {
      sut_item = try JSONDecoder().decode(ProductSearchResponse.self, from: itemAsset.data)
    } catch {
      XCTFail()
      print(MockServiceError.search)
    }
  }
}

extension MockItemSearcher: ItemSearcherProtocol {
  func search(id: Int, completionHandler: @escaping (ProductSearchResponse?) -> ()) {
    searchWasCalled = true
    
    if shouldReturnError {
      completionHandler(nil)
      XCTFail()
    } else {
      completionHandler(sut_item)
    }
  }
}
