//
//  OpenMarketJSONTests.swift
//  OpenMarketJSONTests
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import XCTest
@testable import OpenMarket

final class OpenMarketJSONTests: XCTestCase {
    private var jsonParser: JsonParser!
    private var mockTestData: NetworkAble!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        jsonParser = JsonParser()
        mockTestData = MockTestData()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        jsonParser = nil
        mockTestData = nil
    }
    
    func test_products_JSON_테스트파일을_decoding해서_결과는_NotNil() {
        // given
        guard let data = mockTestData.inquireProductList() else {
            XCTFail()
            return
        }
        
        // when
        let pageInformation: PageInformation? = jsonParser.decodingJson(json: data)
        
        // then
        XCTAssertNotNil(pageInformation)
        XCTAssertNotNil(pageInformation?.pages)
    }
}

