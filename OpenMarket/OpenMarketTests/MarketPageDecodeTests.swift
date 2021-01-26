//
//  MarketPageDecodeTests.swift
//  OpenMarketTests
//
//  Created by Kyungmin Lee on 2021/01/26.
//

import XCTest
@testable import OpenMarket

class MarketPageDecodeTests: XCTestCase {

    private var decodedMarketPage: MarketPage?
    
    override func setUp() {
        guard let mockDataAsset = NSDataAsset(name: "items") else {
            XCTFail("Failed to load dataAsset")
            return
        }
        if let decodedData: MarketPage = try? JSONDecoder().decode(MarketPage.self, from: mockDataAsset.data) {
            decodedMarketPage = decodedData
        } else {
            XCTFail("Failed to decode dataAsset")
            return
        }
    }
       
    func testDecodeMarketItemWithMock() {
        guard let decodedMarketPage = self.decodedMarketPage else {
            XCTFail("Failed to decode dataAsset")
            return
        }
        let decodedMarketItem = decodedMarketPage.marketItems[0]
        guard decodedMarketItem.images == nil,
              decodedMarketItem.descriptions == nil else {
            XCTFail("Failed to decode dataAsset")
            return
        }
        guard let thumbnails = decodedMarketItem.thumbnails else {
            XCTFail("Failed to decode dataAsset")
            return
        }
        
        XCTAssertEqual(decodedMarketItem.id, 1)
        XCTAssertEqual(decodedMarketItem.title, "MacBook Air")
        XCTAssertEqual(decodedMarketItem.price, 1290000)
        XCTAssertEqual(decodedMarketItem.currency, "KRW")
        XCTAssertEqual(decodedMarketItem.stock, 1000000000000)
        XCTAssertEqual(decodedMarketItem.discountedPrice, nil)
        for i in 0...2 {
            XCTAssertEqual(thumbnails[i], "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-\(i + 1).png")
        }
        XCTAssertEqual(decodedMarketItem.registrationDate, 1611523563.719116)
    }
}
