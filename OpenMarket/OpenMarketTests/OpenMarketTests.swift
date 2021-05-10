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
        let url = URL(string: "https://camp-open-market-2.herokuapp.com/item/1")
        let response = try? String(contentsOf: url!)
        print(response)
        XCTAssertNil(response)
    }
    
    
}
