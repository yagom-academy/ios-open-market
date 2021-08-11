//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Luyan, Ellen on 2021/08/11.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    let jsonHandler: JsonHandler! = JsonHandler()
    
    let dummyItem = Item(id: 1, title: "MacBook Pro", descriptions: "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.", price: 1690000, currency: "KRW", stock: 1000000000000, discountedPrice: nil, thumbnails: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png", "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"], images: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png", "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"], registrationDate: 1611523563.719116)
    
    let dummyItemCollection = ItemCollection(page: 1, items:[Item(id: 1, title: "MacBook Pro", descriptions: nil, price: 1690, currency: "USD", stock: 0, discountedPrice: nil,
                                                                 thumbnails: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                                                                              "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"],
                                                                 images: nil, registrationDate: 1611523563.7237701)])
    
    
    func test_MockData인_Item파일을_Item타입으로_디코딩에_성공한다() {
        //given
        let expectResult = dummyItem
        //when
        let result = try! jsonHandler.decodeJsonData(fileName: "Item", model: Item.self)
        //then
        XCTAssertEqual(result, expectResult)
    }
    
    func test_MockData인_Items파일을_ItemCollection타입으로_디코딩에_성공한다() {
        //given
        let expectResult = dummyItemCollection
        //when
        let result = try! jsonHandler.decodeJsonData(fileName: "Items", model: ItemCollection.self)
        //then
        XCTAssertEqual(result.items[0], expectResult.items[0])
    }
    
    func test_MockData파일과_디코딩할타입이_다를경우_디코딩에_실패한다() {
        //given
        let expectError: DecodeError = DecodeError.notFoundFile
        //when
        do {
            _ = try jsonHandler.decodeJsonData(fileName: "item", model: Item.self)
        } catch let result as DecodeError {
            //then
            XCTAssertEqual(result, expectError)
        } catch { }
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
