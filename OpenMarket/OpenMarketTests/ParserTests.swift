//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 이호영 on 2022/01/03.
//

import XCTest
@testable import OpenMarket

class ParserTests: XCTestCase {

    let parser: Parser = Parser()
    
    func test_Products_parsing() {
        let title = "products"
        
        let parsing = parser.decode(fileName: title, decodingType: Products.self)
        let result = try? parsing.get()
        
        XCTAssertEqual(5, result?.totalCount)
        XCTAssertEqual(5, result?.pages.count)
        XCTAssertEqual("Test Product", result?.pages[2].name)
    }
}
