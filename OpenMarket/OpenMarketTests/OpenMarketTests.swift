//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 윤재웅 on 2021/05/12.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    var getItems: GetItems?
    var getItem: GetItem?
    var marketItemsData: MarketItems?
    var marketItemData: MarketItem?
    
    override func setUpWithError() throws {
        self.getItems = GetItems(page: 1)
        self.getItem = GetItem(id: 43)
    }

    override func tearDownWithError() throws {
        self.getItems = nil
        self.getItem = nil
        self.marketItemsData = nil
        self.marketItemData = nil
    }
    
    func test_목록조회_page_테스트() {
        guard let marketItems = NSDataAsset(name: "Items") else {
            XCTAssert(false)
            return
        }
        do {
            let result = try JSONDecoder().decode(MarketItems.self, from: marketItems.data)
            XCTAssertEqual(result.page, 1)
        } catch {
            XCTAssert(false)
        }
    }
    
    func test_목록조회_Items_테스트() {
        guard let marketItems = NSDataAsset(name: "Items") else {
            XCTAssert(false)
            return
        }
        do {
            let result = try JSONDecoder().decode(MarketItems.self, from: marketItems.data)
            XCTAssertEqual(result.items.first?.id, 1)
            XCTAssertEqual(result.items.first?.title, "MacBook Pro")
            XCTAssertEqual(result.items.first?.price, 1690)
            XCTAssertEqual(result.items.first?.currency, "USD")
            XCTAssertEqual(result.items.first?.stock, 0)
            XCTAssertEqual(result.items.first?.thumbnails, [
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
            ])
            XCTAssertEqual(result.items.first?.registrationData, 1611523563.7237701)
        } catch {
            XCTAssert(false)
        }
    }
    
    func test_상품조회_테스트() {
        guard let marketItem = NSDataAsset(name: "Item") else {
            XCTAssert(false)
            return
        }
        do {
            let result = try JSONDecoder().decode(MarketItem.self, from: marketItem.data)
            XCTAssertEqual(result.id, 1)
            XCTAssertEqual(result.title, "MacBook Pro")
            XCTAssertEqual(result.descriptions, "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.")
            XCTAssertEqual(result.price, 1690000)
            XCTAssertEqual(result.currency, "KRW")
            XCTAssertEqual(result.stock, 1000000000000)
            XCTAssertEqual(result.discountedPrice, 0)
            XCTAssertEqual(result.thumbnails, [
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
            ])
            XCTAssertEqual(result.images, [
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
            ])
            XCTAssertEqual(result.registrationData, 1611523563.719116)
        } catch {
            XCTAssert(false)
        }
    }
    
    func test_네트워크_Items_잘들어오냐() {
        let exception = XCTestExpectation()
        getItems?.network(completion: { data in
            guard let data = data else {
                XCTAssert(false)
                return
            }
            self.marketItemsData = data
            exception.fulfill()
        })
        wait(for: [exception], timeout: 10.0)
        XCTAssertEqual(marketItemsData?.page, 1)
        XCTAssertEqual(marketItemsData?.items.first?.id, 43)
        XCTAssertEqual(marketItemsData?.items.first?.title, "Apple Pencil")
        XCTAssertEqual(marketItemsData?.items.first?.price, 165)
        XCTAssertEqual(marketItemsData?.items.first?.currency, "USD")
        XCTAssertEqual(marketItemsData?.items.first?.discountedPrice, 160)
        XCTAssertEqual(marketItemsData?.items.first?.stock, 5000000)
        XCTAssertEqual(marketItemsData?.items.first?.thumbnails, [
                       "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/3371E602-2C29-4734-8A9A-83A37DD24EAE.png",
                       "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/847BD5A2-8BFF-4A7F-BAD4-75E59330445D.png"
        ])
        XCTAssertEqual(marketItemsData?.items.first?.registrationData, 1620633347.3906322)
        
    }
    
    func test_네트워크_Item_잘들어오냐() {
        let exception = XCTestExpectation()
        getItem?.network(completion: { data in
            guard let data = data else {
                XCTAssert(false)
                return
            }
            self.marketItemData = data
            exception.fulfill()
        })
        wait(for: [exception], timeout: 10.0)
        XCTAssertEqual(marketItemData?.id, 43)
        XCTAssertEqual(marketItemData?.title, "Apple Pencil")
        XCTAssertEqual(marketItemData?.descriptions, "Apple Pencil은 그림을 그리고, 메모를 적고, 뭔가 끄적거리는 행위가 어떤 느낌으로 이루어져야 하는지에 대한 기준을 제시합니다.\n직관적이고, 정밀하면서도 사뭇 신기롭죠. 거의 인지 못할 정도로 짧은 지연 시간과 픽셀 단위의 정밀함, 기울기와 압력 감지 기능, 팜리젝션 기능까지 모두 갖추고 있습니다.\n영감이 떠오른 순간, 바로 아이디어를 구체화할 수 있죠.")
        XCTAssertEqual(marketItemData?.price, 165)
        XCTAssertEqual(marketItemData?.currency, "USD")
        XCTAssertEqual(marketItemData?.stock, 5000000)
        XCTAssertEqual(marketItemData?.discountedPrice, 160)
        XCTAssertEqual(marketItemData?.thumbnails, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/3371E602-2C29-4734-8A9A-83A37DD24EAE.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/847BD5A2-8BFF-4A7F-BAD4-75E59330445D.png"
        ])
        XCTAssertEqual(marketItemData?.images, [
                       "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/3371E602-2C29-4734-8A9A-83A37DD24EAE.png",
                       "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/847BD5A2-8BFF-4A7F-BAD4-75E59330445D.png"
        ])
        XCTAssertEqual(marketItemData?.registrationData, 1620633347.3906322)
    }

}
