//
//  APIServiceTests.swift
//  OpenMarketTests
//
//  Created by 권나영 on 2022/01/07.
//

import XCTest
@testable import OpenMarket

class APIServiceTests: XCTestCase {

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
}

extension Page: Equatable {
    public static func == (lhs: Page, rhs: Page) -> Bool {
        return lhs.pageNumber == rhs.pageNumber &&
            lhs.itemsPerPage == rhs.itemsPerPage &&
            lhs.totalCount == rhs.totalCount &&
            lhs.offset == rhs.offset &&
            lhs.limit == rhs.limit &&
            lhs.products == rhs.products &&
            lhs.lastPage == rhs.lastPage &&
            lhs.hasNext == rhs.hasNext &&
            lhs.hasPrevious == rhs.hasPrevious
    }
}
