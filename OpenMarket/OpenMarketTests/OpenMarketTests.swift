//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Sunny, James on 2021/05/11.
//

import XCTest
@testable import OpenMarket
class OpenMarketTests: XCTestCase {
    private var sut_marketItemList: MarketItemList?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        guard let marketListAsset = NSDataAsset.init(name: "Items") else { return }
        sut_marketItemList = try JSONDecoder().decode(MarketItemList.self, from: marketListAsset.data)
        
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut_marketItemList = nil
    }
    
    func test_marketItemList_page() {
        guard let marketItemList = sut_marketItemList else {
            XCTAssert(false)
            return
            
        }
        XCTAssertEqual(marketItemList.page, 2)
    }
    
    func test_marketItemList_items_thumbnails() {
        guard let marketItemList = sut_marketItemList else {
            XCTFail()
            return
            
        }
        XCTAssertNil(marketItemList.items[0].thumbnails)
        XCTAssertEqual(marketItemList.items[0].thumbnails[1], "aa")
    }


}
