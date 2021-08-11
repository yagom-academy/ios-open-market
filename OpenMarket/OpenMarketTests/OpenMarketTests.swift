//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 박태현 on 2021/08/11.
//

import XCTest
@testable import OpenMarket
class OpenMarketTests: XCTestCase {
    
    let testItem = ItemData(id: 1,
                                   title: "MacBook Pro",
                                   price: 1690000,
                                   currency: "KRW",
                                   stock: 1000000000000,
                                   discountedPrice: nil,
                                   thumbnails: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                                            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"],
                                   registrationDate: 1611523563.719116,
                                   descriptions: "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.",
                                   images: [
                                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
                                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
                                   ])
            
    let testItems = [ItemData(id: 1,
                                 title: "MacBook Pro",
                                 price: 1690,
                                 currency: "USD",
                                 stock: 0,
                                 discountedPrice: nil,
                                 thumbnails: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                                     "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"],
                                 registrationDate: 1611523563.7237701,
                                 descriptions: nil,
                                 images: nil),
                        ItemData(id: 5,
                                 title: "MacBook Pro",
                                 price: 165,
                                 currency: "USD",
                                 stock: 5000000,
                                 discountedPrice: 160,
                                 thumbnails: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/5-1.png",
                                     "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/5-2.png"],
                                 registrationDate: 1611523563.725668,
                                 descriptions: nil,
                                 images: nil),]
    
    func test_ItemsData_타입으로_디코딩을_성공한다() {
        //given
        let jsonData = try! JSONEncoder().encode(testItems)
        //when
        let decodedData = try! JsonDecoder.decodedJsonFromURLData(type: [ItemData].self, data: jsonData)
        //then
        XCTAssertEqual(decodedData, testItems)
    }
    
    func test_ItemsData_타입으로_디코딩을_실패한다() {
        //given
        let jsonData = try! JSONEncoder().encode(testItems)
        //when
        do {
            _ = try JsonDecoder.decodedJsonFromURLData(type: [ItemData].self, data: jsonData)
        } catch let error as JsonError {
            //then
            XCTAssertEqual(error, JsonError.decodingFailed)
        } catch { }
        
        
    }

    
    func test_ItemData_타입으로_디코딩을_성공한다() {
        //given
        let jsonData = try! JSONEncoder().encode(testItem)
        //when
        let decodedData = try! JsonDecoder.decodedJsonFromURLData(type: ItemData.self, data: jsonData)
        //then
        XCTAssertEqual(decodedData, testItem)
    }

    
    func test_ItemData_타입으로_디코딩을_실패한다() {
        //given
        let jsonData = try! JSONEncoder().encode(testItem)
        //when
        do {
            _ = try JsonDecoder.decodedJsonFromURLData(type: ItemData.self, data: jsonData)
        } catch let error as JsonError {
            //then
            XCTAssertEqual(error, JsonError.decodingFailed)
        } catch { }
    }

}
