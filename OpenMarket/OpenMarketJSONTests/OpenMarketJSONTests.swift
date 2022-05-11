//
//  OpenMarketJSONTests.swift
//  OpenMarketJSONTests
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import XCTest
@testable import OpenMarket

final class OpenMarketJSONTests: XCTestCase {
    private var mockTestData: NetworkAble!
    private var testData: NetworkAble!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockTestData = MockTestData()
        testData = Network()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockTestData = nil
        testData = nil
    }
    
    func test_products_JSON_테스트파일을_decoding해서_결과는_NotNil() {
        // given
        let promise = expectation(description: "비동기 메서드 테스트")
        let pageNo = 2
        let itemsPerPage = 10
        let url = OpenMarketApi.pageInformation(pageNo: pageNo, itemsPerPage: itemsPerPage).string
        
        // when
        mockTestData.requestData(url: url) { data, response, error in
            guard error == nil else { return }
            guard let data = data,
                    let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }
            
        // then
            XCTAssertNotNil(pageInformation)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
    
    func test_pageInformation_decoding해서_결과는_NotNil() {
        // given
        let promise = expectation(description: "비동기 메서드 테스트")
        let pageNo = 2
        let itemsPerPage = 10
        let url = OpenMarketApi.pageInformation(pageNo: pageNo, itemsPerPage: itemsPerPage).string
        
        // when
        testData.requestData(url: url) { data, response, error in
            guard error == nil else { return }
            
            let successsRange = 200..<300
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    successsRange.contains(statusCode) else { return }
            
            guard let data = data,
                    let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }
        
        // then
            XCTAssertNotNil(pageInformation)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
    
    func test_productDetail_decoding해서_결과는_NotNil() {
        // given
        let promise = expectation(description: "비동기 메서드 테스트")
        let target = 2049
        let url = OpenMarketApi.productDetail(productNumber: target).string
        
        // when
        testData.requestData(url: url) { data, response, error in
            guard error == nil else { return }
            
            let successsRange = 200..<300
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    successsRange.contains(statusCode) else { return }
            
            guard let data = data,
                  let productDetail = try? JSONDecoder().decode(ProductDetail.self, from: data) else { return }
        
        // then
            XCTAssertNotNil(productDetail)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
}

