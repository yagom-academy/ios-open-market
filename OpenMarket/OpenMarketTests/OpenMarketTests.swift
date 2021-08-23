//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Luyan, Ellen on 2021/08/11.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    var jsonHandler: JsonHandler!
    let itemDummyData = Item(id: 1,
                             title: "MacBook Pro",
                             descriptions: "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.",
                             price: 1690000,
                             currency: "KRW",
                             stock: 1000000000000,
                             discountedPrice: nil,
                             thumbnails: [
                                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
                             ],
                             images: [
                                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
                                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
                             ],
                             registrationDate: 1611523563.719116)
    
    let itemCollectionDummyData = ItemCollection(page: 1,
                                                 items: [Item(id: 1,
                                                              title: "MacBook Pro",
                                                              descriptions: nil,
                                                              price: 1690,
                                                              currency: "USD",
                                                              stock: 0,
                                                              discountedPrice: nil,
                                                              thumbnails: [
                                                                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                                                                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
                                                              ],
                                                              images: nil,
                                                              registrationDate: 1611523563.7237701)])
    
    override func setUp() {
        jsonHandler = JsonHandler()
    }
    
    func test_Item_타입으로_디코딩에_성공한다() {
        // given
        let jsonData = JsonUtil.loadJsonData("Item")!
        let expectResult = itemDummyData
        // when
        guard let result = try? jsonHandler.decodeJSONData(json: jsonData, model: Item.self) else { return XCTFail() }
        // then
        XCTAssertEqual(result, expectResult)
    }
    
    func test_ItemCollection_타입으로_디코딩에_성공한다() {
        // given
        let jsonData = JsonUtil.loadJsonData("Items")!
        let expectResult = itemCollectionDummyData
        // when
        guard let result = try? jsonHandler.decodeJSONData(json: jsonData, model: ItemCollection.self) else { return XCTFail() }
        // then
        XCTAssertEqual(result.page, expectResult.page)
        XCTAssertEqual(result.items[0], expectResult.items[0])
    }
    
    func test_매핑할_타입이_달라_decodeFail_에러가_반환된다() {
        // given
        let jsonData = JsonUtil.loadJsonData("Item")!
        // when
        do {
            _ = try jsonHandler.decodeJSONData(json: jsonData, model: ItemCollection.self)
        } catch DecodeError.decodeFail {
            // then
            XCTAssertTrue(true)
        } catch {
            XCTAssertFalse(true)
        }
    }
}

extension Item: Equatable {
    public static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.descriptions == rhs.descriptions &&
            lhs.price == rhs.price &&
            lhs.currency == rhs.currency &&
            lhs.stock == rhs.stock &&
            lhs.discountedPrice == rhs.discountedPrice &&
            lhs.thumbnails == rhs.thumbnails &&
            lhs.images == rhs.images &&
            lhs.registrationDate == rhs.registrationDate
    }
}

extension ItemCollection: Equatable {
    public static func == (lhs: ItemCollection, rhs: ItemCollection) -> Bool {
        return lhs.page == rhs.page && lhs.items == lhs.items
    }
}
