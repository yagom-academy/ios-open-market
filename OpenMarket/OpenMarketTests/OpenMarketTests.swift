//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 황인우 on 2021/05/11.
//

import XCTest
@testable import OpenMarket
class OpenMarketTests: XCTestCase {
    private var sut_marketItemList: MarketItemList?
    private var sut_marketItems: MarketItems?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        guard let marketListAsset = NSDataAsset.init(name: "Items"),
              let marketItemAsset = NSDataAsset.init(name: "Item") else { return }
        sut_marketItemList = try JSONDecoder().decode(MarketItemList.self, from: marketListAsset.data)
        sut_marketItems = try JSONDecoder().decode(MarketItems.self, from: marketItemAsset.data)

    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut_marketItems = nil
        sut_marketItemList = nil
    }

}
