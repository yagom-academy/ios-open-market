//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 이성노 on 2021/05/13.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {

    func test_parser메소드를_통해_디코딩된_data가_mockData와_같은지_확인하는함수() {
        var jsonParserItem = JSONParser<Item>()
        
        jsonParserItem.parse(assetName: "Item")
        
        guard let data: Item = jsonParserItem.convertedData else {
            XCTFail()
            return
        }
        
        let mockData = Item(id: 1,
                            title: "MacBook Pro",
                            descriptions: "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.",
                            price: 1690000,
                            currency: "KRW",
                            stock: 1000000000000,
                            thumbnails: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                                         "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"],
                            images: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
                                     "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"],
                            registrationDate: 1611523563.719116)
        
        XCTAssertEqual(mockData.thumbnails, data.thumbnails)
    }
    
    func test_parser메소드를_통해_디코딩된_datas의_page값이_1인지확인해보는_함수() {
        var jsonParserItems = JSONParser<Items>()
        
        jsonParserItems.parse(assetName: "Items")
        
        guard let datas: Items = jsonParserItems.convertedData else { return }
        
        XCTAssertEqual(datas.page, 1)
    }
}
