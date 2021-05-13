//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Sunny, James on 2021/05/11.
//

import XCTest
@testable import OpenMarket
class OpenMarketJSONParsingTests: XCTestCase {
    private var sut_marketItemList: MarketItemList?
    private var sut_Item: Item?
    
    // MARK:- JSONParsing
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        guard let marketListAsset = NSDataAsset.init(name: "Items") else { return }
        guard let itemAsset = NSDataAsset.init(name: "Item") else { return }
        sut_marketItemList = try JSONDecoder().decode(MarketItemList.self, from: marketListAsset.data)
        sut_Item = try JSONDecoder().decode(Item.self, from: itemAsset.data)
        
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut_marketItemList = nil
    }
    
    // MARK:- Test: Validate Data
    
    func test_marketItemList_validate_data() {
        guard let marketItemList = sut_marketItemList else {
            XCTAssert(false)
            return
            
        }
        XCTAssertEqual(marketItemList.page, 1)
        XCTAssertEqual(marketItemList.items[0].id, 1)
        XCTAssertEqual(marketItemList.items[0].title, "MacBook Pro")
        XCTAssertEqual(marketItemList.items[0].price, 1690)
        XCTAssertEqual(marketItemList.items[0].currency, "USD")
        XCTAssertEqual(marketItemList.items[0].stock, 0)
        XCTAssertEqual(marketItemList.items[0].registrationDate, 1611523563.7237701)
    }
    
    func test_marketItemList_items_validate_thumbnails() {
        guard let marketItemList = sut_marketItemList else {
            XCTFail()
            return
            
        }
        XCTAssertEqual(marketItemList.items[0].thumbnails[0], "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png")
        XCTAssertEqual(marketItemList.items[1].thumbnails[0], "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/2-1.png")
    }
    
    func test_item_validate_data() {
        guard let item = sut_Item else {
            XCTFail()
            return
        }
        XCTAssertEqual(item.id, 1)
        XCTAssertEqual(item.title, "MacBook Pro")
        XCTAssertEqual(item.descriptions, "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.")
        XCTAssertEqual(item.price, 1690000)
        XCTAssertEqual(item.currency, "KRW")
        XCTAssertEqual(item.stock, 1000000000000)
        XCTAssertEqual(item.registrationDate, 1611523563.719116)
    }
    
    func test_item_validate_thumbnails() {
        guard let item = sut_Item else {
            XCTFail()
            return
        }
        XCTAssertEqual(item.thumbnails[0], "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png")
        XCTAssertEqual(item.thumbnails[1], "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png")
    }
    
    func test_item_validate_images() {
        guard let item = sut_Item else {
            XCTFail()
            return
        }
        XCTAssertEqual(item.images?[0], "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png")
        XCTAssertEqual(item.images?[1], "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png")
    }
    
    // MARK:- Test: Check Nil or Not
    
    func test_marketItemList_checkForNil_images() {
        guard let marketItemList = sut_marketItemList else {
            XCTFail()
            return
            
        }
        XCTAssertNil(marketItemList.items[0].images)
    }
    
    func test_item_checkForNil_images() {
        guard let item = sut_Item else {
            XCTFail()
            return
        }
        XCTAssertNil(item.images)
    }
    
    func test_marketItemList_checkForNil_descriptions() {
        guard let marketItemList = sut_marketItemList else {
            XCTFail()
            return
        }
        
        XCTAssertNil(marketItemList.items[0].descriptions)
    }
    
    func test_item_checkForNil_descriptions() {
        guard let item = sut_Item else {
            XCTFail()
            return
        }
        
        XCTAssertNil(item.descriptions)
    }
}
