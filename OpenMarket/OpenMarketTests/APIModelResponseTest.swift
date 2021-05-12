//
//  APIModelTest.swift
//  OpenMarketTests
//
//  Created by 기원우 on 2021/05/12.
//

import XCTest
@testable import OpenMarket

class APIModelResponseTest: XCTestCase {
    
    func test_GET_ItemListSearchResponse() {
        let jsonData = try! JsonDecoder.jsonDataLoad(dataName: "Items")
        let GETItemList = try! JSONDecoder().decode(ItemListSearchResponse.self, from: jsonData)
        
        XCTAssertEqual(GETItemList.page, 1)
        XCTAssertEqual(GETItemList.items[7].id, 8)
        XCTAssertEqual(GETItemList.items[7].title, "AirPods Max")
        XCTAssertEqual(GETItemList.items[7].price, 719)
        XCTAssertEqual(GETItemList.items[7].currency, "USD")
        XCTAssertEqual(GETItemList.items[7].stock, 1000000000000)
        XCTAssertEqual(GETItemList.items[7].discountedPrice, 500)
        XCTAssertEqual(GETItemList.items[7].thumbnails, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/8-1.png"
        ])
        XCTAssertEqual(GETItemList.items[7].registerationDate, 1611523563.727608)
    }
    
    func test_GET_ItemSearchResponse() {
        let jsonData = try! JsonDecoder.jsonDataLoad(dataName: "Item")
        let GETResponseItem = try! JSONDecoder().decode(ItemSearchResponse.self, from: jsonData)
        
        XCTAssertEqual(GETResponseItem.id, 1)
        XCTAssertEqual(GETResponseItem.title, "MacBook Pro")
        XCTAssertEqual(GETResponseItem.descriptions, "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.")
        XCTAssertEqual(GETResponseItem.price, 1690000)
        XCTAssertEqual(GETResponseItem.currency, "KRW")
        XCTAssertEqual(GETResponseItem.stock, 1000000000000)
        XCTAssertEqual(GETResponseItem.thumbnails, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
        ])
        XCTAssertEqual(GETResponseItem.images, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
        ])
        XCTAssertEqual(GETResponseItem.registrationDate, 1611523563.719116)
    }
}
