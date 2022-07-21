//
//  RequestTests.swift
//  OpenMarketTests
//
//  Created by groot, bard on 2022/07/12.
//

import XCTest
@testable import OpenMarket

struct GetData: APIRequest {
    var path: URLAdditionalPath = .product
    var method: HTTPMethod = .get
    var baseURL: String {
        URLHost.openMarket.url + path.value
    }
    var headers: [String : String]?
    var query: [URLQueryItem]? = [
        URLQueryItem(name: "page_no", value: "\(1)"),
        URLQueryItem(name: "items_per_page", value: "\(1)")
    ]
    var body: Data?
}

struct PatchData: APIRequest {
    var path: URLAdditionalPath = .product
    var method: HTTPMethod = .patch
    var baseURL: String {
        URLHost.openMarket.url + path.value
    }
    var headers: [String : String]?
    var query: [URLQueryItem]? = [
        URLQueryItem(name: "page_no", value: "\(1)"),
        URLQueryItem(name: "items_per_page", value: "\(1)")
    ]
    var body: Data?
}

final class RequestTests: XCTestCase {
    var sut: GetData?
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = GetData()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_mockSession을받아와서_디코딩이잘되는지() {
        // given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        var resultName: String?
        let mockSession = MockSession()
        
        mockSession.dataTask(with: sut!) { (result: Result<ProductsDetailList, Error>) in
            switch result {
            case .success(let success):
                resultName = success.pages[0].name
            case .failure(_):
                break
            }
            expectation.fulfill()
        }
            
        wait(for: [expectation], timeout: 300)
        
        // when
        let result = "Test Product"
        
        // then
        XCTAssertEqual(result, resultName)
    }
    
    func test_APIRequest를_받아와서_디코딩이_잘되는지() {
        // given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        var resultName: String?
        let myURLSession = MyURLSession()
        
        myURLSession.dataTask(with: sut!) { (result: Result<ProductsDetailList, Error>) in
            switch result {
            case .success(let success):
                resultName = success.pages[0].name
            case .failure(_):
                break
            }
            expectation.fulfill()
        }
            
        wait(for: [expectation], timeout: 300)
        
        // when
        let result = "데릭"
        
        // then
        XCTAssertEqual(result, resultName)
    }
    
    func test_patch를_잘_하는지() {
        
    }
}
