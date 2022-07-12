//
//  RequestTests.swift
//  OpenMarketTests
//
//  Created by groot, bard on 2022/07/12.
//

import XCTest
@testable import OpenMarket

class RequestTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func test_APIRequest를_받아와서_디코딩이_잘되는지() {
        // given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        struct RequestData: APIRequest {}
        let requestData = RequestData()
        let url = URLHost.openMarket + URLAdditionalPath.product
        let pageNumber = URLQueryItem(name: "page_no", value: "\(1)")
        let itemPerPage = URLQueryItem(name: "items_per_page", value: "\(1)")
        let urlQueryItems = [pageNumber, itemPerPage]
        var resultName: String?
        
        // when
        requestData.request(url: url, with: urlQueryItems)
        { (result: Result<ProductsDetailList, Error>) in
            switch result {
            case .success(let data):
                resultName = data.pages[0].name
            case .failure(let error):
                print(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 300)
        
        let result = "1"
        
        // then
        XCTAssertEqual(result, resultName)
    }
    
    func test_mockDataResponse를_받아와서_decoding이잘되는지() {
        // given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        struct RequestData: APIRequest {}
        let requestData = RequestData()
        let url = URLHost.openMarket + URLAdditionalPath.product
        let pageNumber = URLQueryItem(name: "page_no", value: "\(1)")
        let itemPerPage = URLQueryItem(name: "items_per_page", value: "\(1)")
        let urlQueryItems = [pageNumber, itemPerPage]
        var resultName: String?
        
        // when
        requestData.requestMockData(url: url, with: urlQueryItems)
        { (result: Result<ProductsDetailList, Error>) in
            switch result {
            case .success(let data):
                resultName = data.pages[0].name
            case .failure(let error):
                print(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 300)
        
        let result = "Test Product"
        
        // then
        XCTAssertEqual(result, resultName)
    }
}
