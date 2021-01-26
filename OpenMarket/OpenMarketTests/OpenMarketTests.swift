//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 김호준 on 2021/01/26.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_market_model() {
        guard let mockURL = Bundle.main.url(forResource: "Mock", withExtension: "json") else {
            XCTFail("Can't get json file")
            return
        }
        do {
            let mockData = try Data(contentsOf: mockURL)
            let mockJSON = try JSONDecoder().decode(Market.self,
                                                    from: mockData)
            XCTAssertEqual(mockJSON.page, 1)
            XCTAssertEqual(mockJSON.itemList[0].id, 26)
            XCTAssertEqual(mockJSON.itemList[0].currency, .KRW)
        } catch {
            XCTFail()
            return
        }
    }
    
    func test_item_model() {
        guard let mockURL = Bundle.main.url(forResource: "MockItem", withExtension: "json") else {
            XCTFail()
            return
        }
        do {
            let mockData = try Data(contentsOf: mockURL)
            let mockJSON = try JSONDecoder().decode(Item.self, from: mockData)
            XCTAssertNotNil(mockJSON.descriptions)
            XCTAssertNotNil(mockJSON.images)
            XCTAssertNil(mockJSON.discountedPrice)
        } catch {
            XCTFail()
            return
        }
    }
}
