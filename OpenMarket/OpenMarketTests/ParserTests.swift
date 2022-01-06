//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 이호영 on 2022/01/03.
//

import XCTest
@testable import OpenMarket

class ParserTests: XCTestCase {

    let parser: JSONParser = JSONParser()
    
    func test_Products_parsing() {
        let title = "products"
        let parsing = parser.decode(fileName: title, decodingType: Products.self)
        let result = try? parsing.get()
        
        XCTAssertEqual(5, result?.totalCount)
        XCTAssertEqual(5, result?.pages.count)
    }
    
    func test_Product_parsing() {
        let title = "product"
        let parsing = parser.decode(fileName: title, decodingType: Product.self)
        let result = try? parsing.get()
        
        XCTAssertEqual("팥빙수", result?.name)
        XCTAssertEqual(2000, result?.price)
        XCTAssertEqual(16, result?.id)
        XCTAssertEqual(.krw, result?.currency)
        XCTAssertTrue(result!.images!.first!.url.contains("yagom-academy"))
    }
}
