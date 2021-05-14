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
  let sut_item: ProductSearchResponse?
  
  init() {
    guard let itemAsset = NSDataAsset.init(name: "Item") else {
      XCTFail()
      sut_item = nil
      return
    }
    do {
      sut_item = try JSONDecoder().decode(ProductSearchResponse.self, from: itemAsset.data)
    } catch {
      XCTFail()
      sut_item = nil
      print(MockServiceError.search)
    }
  }
  
  enum MockServiceError: Error {
    case search
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
