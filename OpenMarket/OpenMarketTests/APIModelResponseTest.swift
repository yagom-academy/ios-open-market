//
//  APIModelResponseTest.swift
//  OpenMarketTests
//
//  Created by 기원우 on 2021/05/12.
//

import XCTest
@testable import OpenMarket

class APIModelResponseTest: XCTestCase {
    
    func test_ItemListSearchResponse_APIModel_Decode() {
        guard let jsonData = NSDataAsset(name: "Items") else {
            XCTFail()
            return
        }
        
        guard let getItemList = try? JSONDecoder().decode(ItemListSearchResponse.self, from: jsonData.data) else {
            XCTFail()
            return
        }
    }
    
    func test_ItemSearchResponse_APIModel_Decode() {
        guard let jsonData = NSDataAsset(name: "Item") else {
            XCTFail()
            return
        }
        
        guard let getResponseItem = try? JSONDecoder().decode(ItemSearchResponse.self, from: jsonData.data) else {
            XCTFail()
            return
        }
    }
    
}
