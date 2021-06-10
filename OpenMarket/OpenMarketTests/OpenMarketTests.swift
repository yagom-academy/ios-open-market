//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by kio on 2021/05/31.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    
    func testMockDataFromAssetItem() {
        guard let jsonData = NSDataAsset(name: "Item") else {
            XCTFail("Item 정보 읽기 실패")
            return
        }
        
        let decoder = JSONDecoder()

        guard let decodeData = try? decoder.decode(ItemDetail.self, from: jsonData.data) else {
            XCTFail("Item 디코딩 실패")
            return
        }
    }
    
    func testMockDataFromAssetItems() {
        guard let jsonData = NSDataAsset(name: "Items") else {
            XCTFail("Items 정보 읽기 실패")
            return
        }
        
        let decoder = JSONDecoder()

        guard let decodeData = try? decoder.decode(ItemPage.self, from: jsonData.data) else {
            XCTFail("Items 디코딩 실패")
            return
        }
    }
}

