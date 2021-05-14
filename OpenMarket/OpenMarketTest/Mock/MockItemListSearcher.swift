//
//  MockItemListSearcher.swift
//  OpenMarketTest
//
//  Created by 이영우 on 2021/05/14.
//
import XCTest
import Foundation
@testable import OpenMarket

class MockItemListSearcher {
  var shouldReturnError = false
  var searchWasCalled = false
  var sut: ListSearchResponse? = nil
  
  init() {
    guard let itemAsset = NSDataAsset(name: "Items") else {
      XCTFail()
      return
    }
    
    do{
      self.sut = try JSONDecoder().decode(ListSearchResponse.self, from: itemAsset.data)
    } catch {
      XCTFail()
      print(MockServiceError.search)
    }
  }
}

extension MockItemListSearcher: ItemListSearcherProtocol {
  func search(page: Int, completionHandler: @escaping (ListSearchResponse?) -> ()) {
    searchWasCalled = true
    
    if shouldReturnError {
      completionHandler(nil)
      XCTFail()
    } else {
      completionHandler(sut)
    }
  }
}
