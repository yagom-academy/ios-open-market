//
//  MarketItemDecodeMockTests.swift
//  OpenMarketTests
//
//  Created by Kyungmin Lee on 2021/01/27.
//

import XCTest
@testable import OpenMarket

class MarketItemDecodeMockDataTests: XCTestCase {
    var sut: MarketItem!
    
    override func setUpWithError() throws {
        if let dataAsset = NSDataAsset(name: "item") {
            sut = try JSONDecoder().decode(MarketItem.self, from: dataAsset.data)
        }
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_decodedMockData() {
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.id, 1)
        XCTAssertEqual(sut.title, "MacBook Air")
        let lastDescriptionWord = sut.descriptions?.components(separatedBy: " ").last
        XCTAssertEqual(lastDescriptionWord, "있습니다.")
        XCTAssertEqual(sut.priceWithCurrency, "KRW 1,290,000")
        XCTAssertEqual(sut.stock, 1000000000000)
        let lastThumbnail = sut.thumbnails?.last
        XCTAssertEqual(lastThumbnail, "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-3.png")
        let lastImage = sut.images?.last
        XCTAssertEqual(lastImage, "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-5.png")
        let date: Date = Date(timeIntervalSince1970: 1611523563.719116)
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy.MM.dd HH:MM"
        let dateString = dateFormatter.string(from: date)
        XCTAssertEqual(sut.registrationGMTDate, dateString)
    }
}
