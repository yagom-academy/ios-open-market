//
//  MarketPageDecodeMockDataTests.swift
//  OpenMarketTests
//
//  Created by Kyungmin Lee on 2021/01/27.
//

import XCTest
@testable import OpenMarket

class MarketPageDecodeMockDataTests: XCTestCase {
    var sut: MarketPage!
    
    override func setUpWithError() throws {
        if let dataAsset = NSDataAsset(name: "items") {
            sut = try JSONDecoder().decode(MarketPage.self, from: dataAsset.data)
        }
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_decodedMockData() {
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.pageNumber, 1)
        let marketItem = sut.marketItems.first
        XCTAssertEqual(marketItem?.id, 1)
        XCTAssertEqual(marketItem?.title, "MacBook Air")
        XCTAssertEqual(marketItem?.priceWithCurrency, "KRW 1,290,000")
        XCTAssertEqual(marketItem?.stock, 1000000000000)
        let lastThumbnail = marketItem?.thumbnails?.last
        XCTAssertEqual(lastThumbnail, "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-3.png")
        let date: Date = Date(timeIntervalSince1970: 1611523563.719116)
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy.MM.dd HH:MM"
        let dateString = dateFormatter.string(from: date)
        XCTAssertEqual(marketItem?.registrationGMTDate, dateString)
    }
}
