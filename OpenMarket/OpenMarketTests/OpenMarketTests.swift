//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 이예원 on 2021/08/11.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {

    var sut: ProductSearch!
    var decoder: JSONDecoder!
    var data: Data!
    
    override func setUpWithError() throws {
        decoder = JSONDecoder()
    }

    override func tearDownWithError() throws {
        decoder = nil
        data = nil
        sut = nil
    }
    
    func test_ProductSearch모델이_Codable을채택한다() {
        XCTAssertTrue((sut as Any) is Codable)
    }

   
}
