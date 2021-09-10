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
    
    func test_Items_에셋파일을_ProductCollection_타입으로_디코딩에_성공하면_title은_MacBookPro다() {
        // given
        let expectInputValue = "Items"
        // when
        guard let jsonData = try? parsingManager?.loadedDataAsset(assetName: expectInputValue),
              let decodedData = try? parsingManager?.decodedJSONData(type: ProductCollection.self, data: jsonData.data) else {
            return XCTFail()
        }
        let expectResult = "MacBook Pro"
        let result = decodedData.items.first?.title
        // then
        XCTAssertEqual(expectResult, result)
    }
    
    func test_Item_에셋파일을_Product_타입으로_디코딩에_성공하면_price는_1690000이다() {
        // given
        let expectInputValue = "Item"
        // when
        guard let jsonData = try? parsingManager?.loadedDataAsset(assetName: expectInputValue),
              let decodedData = try? parsingManager?.decodedJSONData(type: Product.self, data: jsonData.data) else {
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
        let expectInputValue = "Item"
        let expectHttpMethod: APIHTTPMethod = .get
        let sut = NetworkManager(session: MockURLSession(isRequestSucess: expectBool),
                                 applicableHTTPMethod: [expectHttpMethod])
        // when
        guard let jsonData = try? parsingManager?.loadedDataAsset(assetName: expectInputValue),
              let decodedData = try? parsingManager?.decodedJSONData(type: Product.self, data: jsonData.data) else {
            return XCTFail()
        }
        sut.commuteWithAPI(api: GetItemAPI(id: 1)) { result in
            switch result {
            // then
            case .success(let item):
                guard let expectedData =
                        try? self.parsingManager?.decodedJSONData(type: Product.self, data: item) else {
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
        let expectHttpMethod: APIHTTPMethod = .post
        let sut = NetworkManager(session: MockURLSession(isRequestSucess: false),
                                 applicableHTTPMethod: [expectHttpMethod])
        // when
        sut.commuteWithAPI(api: GetItemAPI(id: 1)) { result in
            if case .failure(let error) = result {
                // then
                XCTAssertEqual(error, NetworkError.invalidHttpMethod)
            }
        }
    }
    
    func test_get을_호출시_리스폰스의_상태코드가_402이면_테스트에_실패한다() {
        // given
        let expectBool = false
        let sut = NetworkManager(session: MockURLSession(isRequestSucess: expectBool), applicableHTTPMethod: [.get])
        // when
        sut.commuteWithAPI(api: GetItemAPI(id: 1)) { result in
            guard case .failure(let error) = result else {
                return XCTFail()
            }
            // then
            XCTAssertEqual(error, NetworkError.responseFailed)
        }
    }
}
