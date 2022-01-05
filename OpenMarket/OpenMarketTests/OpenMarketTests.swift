//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Jun Bang on 2022/01/05.
//

import XCTest

class OpenMarketTests: XCTestCase {
    var sut: MarketAPIService!
    
    override func setUpWithError() throws {
        sut = MarketAPIService()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testParsePage_productsJSONFile_expectCorrectProperties() {
        // given
        guard let data = NSDataAsset(name: "products")?.data else {
            return
        }
        guard let page: Page = sut.parse(with: data) else {
            return
        }
        
        //then
        let pageNumber = page.pageNumber
        let itemsPerPage = page.itemsPerPage
        let totalCount = page.totalCount
        let offset = page.offset
        let limit = page.limit
        
        //expected
        XCTAssertEqual(pageNumber, 1)
        XCTAssertEqual(itemsPerPage, 20)
        XCTAssertEqual(totalCount, 10)
        XCTAssertEqual(offset, 0)
        XCTAssertEqual(limit, 20)
    }
}
