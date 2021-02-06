//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 김호준 on 2021/01/26.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    func test_networkconfig_makeURLPath_fetchGoodsList() {
        let path = NetworkEndPoints.makeURLPath(api: .fetchGoodsList, with: 1)
        let targetPath = "/items/1"
        XCTAssertEqual(targetPath, path)
    }
    
    func test_networkconfig_makeURLPath_fetchGoods() {
        let path = NetworkEndPoints.makeURLPath(api: .fetchGoods, with: 1)
        let targetPath = "/item/1"
        XCTAssertEqual(targetPath, path)
    }
    
    func test_networkconfig_makeURLPath_registerGoods() {
        let path = NetworkEndPoints.makeURLPath(api: .registerGoods, with: nil)
        let targetPath = "/item"
        XCTAssertEqual(targetPath, path)
    }
    
    func test_networkconfig_makeURLPath_editGoods() {
        let path = NetworkEndPoints.makeURLPath(api: .editGoods, with: 1)
        let targetPath = "/item/1"
        XCTAssertEqual(targetPath, path)
    }
    
    func test_networkconfig_makeURLPath_removeGoods() {
        let path = NetworkEndPoints.makeURLPath(api: .removeGoods, with: 1)
        let targetPath = "/item/1"
        XCTAssertEqual(targetPath, path)
    }
    
    func test_fetchMarketGoodsList_request() {
        let expectation = XCTestExpectation(description: "fetch market goods list data")
        FetchMarketGoodsList().requestFetchMarketGoodsList(page: 1) { result in
            switch result {
            case .success(let decodedData):
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_fetchGoods_request() {
        let expectation = XCTestExpectation(description: "fetch goods data")
        FetchGoods().requestFetchGoods(id: 344) { result in
            switch result {
            case .success(let decodedData):
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_decode_mock_data_with_market_model() {
        guard let mockURL = Bundle.main.url(forResource: "Mock", withExtension: "json") else {
            XCTFail("Can't get json file")
            return
        }
        do {
            let mockRawData = try Data(contentsOf: mockURL)
            let mockDecodedJSON = try JSONDecoder().decode(MarketGoods.self,
                                                    from: mockRawData)
            XCTAssertEqual(mockDecodedJSON.page, 1)
            XCTAssertEqual(mockDecodedJSON.list[0].id, 26)
            XCTAssertEqual(mockDecodedJSON.list[0].currency, "KRW")
        } catch {
            XCTFail()
            return
        }
    }
    
    func test_decode_mock_data_with_goods_model() {
        guard let mockURL = Bundle.main.url(forResource: "MockItem", withExtension: "json") else {
            XCTFail()
            return
        }
        do {
            let mockRawData = try Data(contentsOf: mockURL)
            let mockDecodedJSON = try JSONDecoder().decode(Goods.self, from: mockRawData)
            XCTAssertNotNil(mockDecodedJSON.descriptions)
            XCTAssertNotNil(mockDecodedJSON.images)
            XCTAssertNil(mockDecodedJSON.discountedPrice)
        } catch {
            XCTFail()
            return
        }
    }
}
