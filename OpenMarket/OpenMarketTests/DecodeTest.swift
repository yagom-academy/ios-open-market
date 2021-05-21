//
//  DecodeTest.swift
//  OpenMarketTests
//
//  Created by 윤재웅 on 2021/05/21.
//

import XCTest
@testable import OpenMarket

class DecodeTest: XCTestCase {
    var mockItems: Data?
    var mockItem: Data?
    var mockDecode: MockDecoder?

    override func setUpWithError() throws {
        mockDecode = MockDecoder()
        mockItems = NSDataAsset(name: "Items")!.data
        mockItem = NSDataAsset(name: "Item")!.data
    }

    override func tearDownWithError() throws {
        mockDecode = nil
        mockItems = nil
        mockItem = nil
    }

    func test_MarketItems_Decode_성공() {
        XCTAssertNotNil(try? mockDecode!.decode(MarketItems.self, from: mockItems!))
    }
    
    func test_MarketItems_Decode_실패() {
        XCTAssertNil(try? mockDecode!.decode(StubMarketItems.self, from: mockItems!))
    }
    
    func test_MarketItem_Decode_성공() {
        XCTAssertNotNil(try? mockDecode!.decode(MarketItem.self, from: mockItem!))
    }
    
    func test_MarketItem_Decode_실패() {
        XCTAssertNil(try? mockDecode!.decode(StubMarketItem.self, from: mockItem!))
    }

}
