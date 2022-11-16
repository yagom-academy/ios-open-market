//
//  MockURLSessionTests.swift
//  MockURLSessionTests
//
//  Created by 써니쿠키, 메네 on 16/11/2022.
//

import XCTest
@testable import OpenMarket

class MockURLSessionTests: XCTestCase {
    let mockSession = MockURLSession()
    var sut: MarketURLSessionProvider!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MarketURLSessionProvider(session: mockSession)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_getUser_success() {
        // 결과 data가 Json 형태라면
        let expectation = XCTestExpectation()
        let response = JSONDecoder.decodeFromSnakeCase(type: Market.self, from: SampleData.sampleData)

        // MockURLSession을 통해 테스트
        guard let url = URL(string: "") else { return }
        sut.fetchData(url: url, type: Market.self) { result in
            switch result {
            case .success(let market):
                XCTAssertEqual(market.totalCount , response?.totalCount)
                XCTAssertEqual(market.pageNo , response?.pageNo)
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
