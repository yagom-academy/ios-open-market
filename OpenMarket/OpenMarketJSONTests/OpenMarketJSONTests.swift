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
    private var testData: NetworkAble!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        jsonParser = JsonParser()
        mockTestData = MockTestData()
        testData = Network()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        jsonParser = nil
        mockTestData = nil
        testData = nil
    }
    
    func test_products_JSON_테스트파일을_decoding해서_결과는_NotNil() {
        let promise = expectation(description: "비동기 메서드 테스트")
 
        let query = [("page_no","1"),("items_per_page","10")]
        let url = "https://market-training.yagom-academy.kr/api/products?"
        
        mockTestData.inquireProductList(url: url, query: query) { data, response, error in
            guard let data = data, let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }
            
            XCTAssertNotNil(pageInformation)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
    
    func test_pageInformation_decoding해서_결과는_NotNil() {
        let promise = expectation(description: "비동기 메서드 테스트")
 
        let query = [("page_no","2"),("items_per_page","10")]
        let url = "https://market-training.yagom-academy.kr/api/products?"
        
        testData.inquireProductList(url: url, query: query) { data, response, error in
            guard let data = data, let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }
            
            XCTAssertNotNil(pageInformation)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
}

