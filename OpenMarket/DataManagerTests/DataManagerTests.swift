//
//  DataManagerTests.swift
//  DataManagerTests
//
//  Created by minsson, yeton on 2022/07/15.
//

import XCTest
@testable import OpenMarket

class DataManagerTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_makeDataFrom메서드_json파일명을_넣을시_옵셔널Data타입으로_반환한다() {
        // given
        let filename = "products"
        
        // when
        let result = NetworkManager.makeDataFrom(fileName: filename)
        
        // then
        XCTAssertTrue(type(of: result) == Data?.self)
    }
    
    func test_mockData를_parse하면_첫번째_아이템_id는_20이다() {
        // given
        let filename = "products"
        guard let data = NetworkManager.makeDataFrom(fileName: filename) else {
            XCTFail("JSON 데이터 파일명 및 형식 확인 필요")
            return
        }
        var itemListPage: ItemListPage?
        
        // when
        let parsedData = NetworkManager.parse(data, into: ItemListPage.self)
        itemListPage = parsedData
        
        let result = itemListPage?.items[0].id
        let expectation = 20
        
        // then
        XCTAssertEqual(result, expectation)
    }
}
