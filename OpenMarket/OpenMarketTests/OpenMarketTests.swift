//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by sookim on 2021/05/11.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {

    func testDecodeEntireArticleItems() {
        let decoder = JSONDecoder()
        guard let itemData = NSDataAsset(name: "Items") else { XCTFail(); return }
        
        do {
            let contents = try decoder.decode(EntireArticle.self, from: itemData.data)
            XCTAssertEqual(contents.page, 1)
        } catch {
            XCTFail()
        }
    }
    
    func testDecodeDetailArticleDescriptions() {
        let decoder = JSONDecoder()
        guard let itemData = NSDataAsset(name: "Item") else { XCTFail(); return }
        
        do {
            let contents = try decoder.decode(DetailArticle.self, from: itemData.data)
            XCTAssertEqual(contents.id, 1)
            XCTAssertEqual(contents.title, "abc")
            XCTAssertEqual(contents.price, 123)
            XCTAssertEqual(contents.descriptions, "abc")
            XCTAssertEqual(contents.currency, "abc")
            XCTAssertEqual(contents.stock, 123)
            XCTAssertEqual(contents.images, [
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
            ])
            XCTAssertEqual(contents.discountedPrice, 123)
            XCTAssertEqual(contents.thumbnails, [
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
            ])
            XCTAssertEqual(contents.registrationDate, 123.12)
            
        } catch {
            XCTFail()
        }
    }
}

