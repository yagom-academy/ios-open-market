//
//  APIServiceTests.swift
//  OpenMarketTests
//
//  Created by 권나영 on 2022/01/07.
//

import XCTest
@testable import OpenMarket

final class APIServiceTests: XCTestCase {
    func testGetPage_givenSuccessfulRequest_expectCorrectData() {
        let mockURLSession = MockURLSession(isSuccessfulRequest: true, mockRequest: .getPage)
        let sut = MarketAPIService(session: mockURLSession)
        let mockData = try? JSONDecoder().decode(Page.self, from: mockURLSession.request.data)
        
        sut.get(pageNumber: 1, itemsPerPage: 1) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, mockData)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testGetPage_givenFailureRequest_expectInvalidRequestError() {
        let mockURLSession = MockURLSession(isSuccessfulRequest: false, mockRequest: .getPage)
        let sut = MarketAPIService(session: mockURLSession)
        
        sut.get(pageNumber: 1, itemsPerPage: 1) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .invalidRequest)
            }
        }
    }
    
    func testGetProduct_givenSuccessfulRequest_expectCorrectData() {
        let mockURLSession = MockURLSession(isSuccessfulRequest: true, mockRequest: .getProduct)
        let sut = MarketAPIService(session: mockURLSession)
        let mockData = try? JSONDecoder().decode(Product.self, from: mockURLSession.request.data)
        
        sut.get(productID: 87) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, mockData)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testGetProduct_givenFailureRequest_expectInvalidRequestError() {
        let mockURLSession = MockURLSession(isSuccessfulRequest: false, mockRequest: .getProduct)
        let sut = MarketAPIService(session: mockURLSession)
        
        sut.get(productID: 87) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .invalidRequest)
            }
        }
    }
}
