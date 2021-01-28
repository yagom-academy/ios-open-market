//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 김호준 on 2021/01/26.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    func test_fetch_market_data_from_server() {
        let expectation = XCTestExpectation(description: "fetch data")
        
        guard let url = URL(string: "https://camp-open-market.herokuapp.com/items/1") else {
            XCTFail("Error with URL")
            return
        }
        
        test_networkconfig_makeurl_method(url: url)
        
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            if error != nil {
                XCTFail()
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                XCTFail()
                return
            }
            
            guard data != nil else {
                XCTFail()
                return
            }
            expectation.fulfill()
        }.resume()
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_networkconfig_makeurl_method(url: URL) {
        XCTAssertEqual(NetworkConfig.makeURL(with: .fetchGoodsList(page: 1)), url)
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
