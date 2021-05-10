//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by TORI on 2021/05/10.
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
    
    func test_URL요청하기() {
        let url = URL(string: "https://camp-open-market-2.herokuapp.com/items/1")
        let response = try? String(contentsOf: url!)
        print(response)
        XCTAssertNotNil(response)
    }
    
    func test_아이템을_받아왔는지_확인() {
        guard let url = URL(string: "https://camp-open-market-2.herokuapp.com/items/1") else {
            XCTFail()
            return
        }
        guard let data = try? String(contentsOf: url).data(using: .utf8) else {
            XCTFail()
            return
        }
        let decoder = JSONDecoder()
        guard let result = try? decoder.decode(OpenMarketItemsList.self, from: data) else {
            XCTFail()
            return
        }

        XCTAssertEqual(result.page, 1)
        XCTAssertEqual(result.items.count, 20)
        XCTAssertEqual(result.items[0].id, 43)
        XCTAssertEqual(result.items[0].stock, 5000000)
        XCTAssertEqual(result.items[0].currency, "USD")
        XCTAssertEqual(result.items[0].title, "Apple Pencil")
        XCTAssertEqual(result.items[0].price, 165)
        XCTAssertEqual(result.items[0].discounted_price, 160)
        XCTAssertEqual(result.items[0].registration_date, 1620633347.3906322)
    }
}
