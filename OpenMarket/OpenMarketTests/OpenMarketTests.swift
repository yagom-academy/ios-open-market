//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by tae hoon park on 2021/08/31.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    var parsingManager: ParsingManager?
    
    override func setUp() {
        super.setUp()
        parsingManager = ParsingManager()
    }
    
    func test_Items_에셋파일을_ItemsData_타입으로_디코딩에_성공하면_title은_MacBookPro다() {
        // given
        let expectInputValue = "Items"
        // when
        guard let jsonData = try? parsingManager?.receivedDataAsset(assetName: expectInputValue),
              let decodedData = try? parsingManager?.decodedJsonData(type: ItemsData.self, data: jsonData.data) else {
            return XCTFail()
        }
        let expectResult = "MacBook Pro"
        let result = decodedData.items.first?.title
        // then
        XCTAssertEqual(expectResult, result)
    }
    
    func test_Item_에셋파일을_ItemData_타입으로_디코딩에_성공하면_price는_1690000이다() {
        // given
        let expectInputValue = "Item"
        // when
        guard let jsonData = try? parsingManager?.receivedDataAsset(assetName: expectInputValue),
              let decodedData = try? parsingManager?.decodedJsonData(type: ItemData.self, data: jsonData.data) else {
            return XCTFail()
        }
        let expectResult = 1690000
        let result = decodedData.price
        // then
        XCTAssertEqual(expectResult, result)
    }
    
    func test_get을_호출시_디코드가_성공하고_리퀘스트_전달에_성공하고_리스폰스를_200번으로_받으면_테스트에_성공한다() {
        // given
        let expectBool = true
        let expectInputValue = "Items"
        let expectHttpMethod: APIMethod = .get
        let sut = NetworkManager(session: MockURLSession(isRequestSucess: expectBool),
                                 valuableMethod: [expectHttpMethod])
        // when
        guard let jsonData = try? parsingManager?.receivedDataAsset(assetName: expectInputValue),
              let decodedData = try? parsingManager?.decodedJsonData(type: ItemData.self, data: jsonData.data) else {
            return XCTFail()
        }
        sut.commuteWithAPI(API: GetItemAPI(id: 1)) { result in
            switch result {
            // then
            case .success(let item):
                guard let expectedData =
                        try? self.parsingManager?.decodedJsonData(type: ItemData.self, data: item) else {
                    return XCTFail()
                }
                XCTAssertEqual(expectedData.title, decodedData.title)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func test_get의_HTTP메서드가_제대로_전달되지_않으면_테스트에_실패한다() {
        // given
        let expectHttpMethod: APIMethod = .post
        let sut = NetworkManager(session: MockURLSession(isRequestSucess: false),
                                 valuableMethod: [expectHttpMethod])
        // when
        sut.commuteWithAPI(API: GetItemAPI(id: 1)) { result in
            if case .failure(let error) = result {
                // then
                XCTAssertEqual(error as? NetworkError, NetworkError.invalidHttpMethod)
            }
        }
    }
    
    func test_get을_호출시_리스폰스의_상태코드가_402이면_테스트에_실패한다() {
        // given
        let expectBool = false
        let sut = NetworkManager(session: MockURLSession(isRequestSucess: expectBool), valuableMethod: [.get])
        // when
        sut.commuteWithAPI(API: GetItemAPI(id: 1)) { result in
            guard case .failure(let error) = result else {
                return XCTFail()
            }
            // then
            XCTAssertEqual(error as? NetworkError, NetworkError.responseFailed)
        }
    }
}
