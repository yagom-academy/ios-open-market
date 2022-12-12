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
    
    func test_mockURLSession_success() {
        // when: MockURLSession 호출결과가 성공일 때,
        sut = MarketURLSessionProvider(session: MockURLSession())
        
        // then: MockURLSession을 통해 테스트
        let expectation = XCTestExpectation()
        
        guard let url = URL(string: "url") else { return }
        
        sut.fetchData(request: URLRequest(url: url)) { result in
            switch result {
            case .success(let market):
                let marketData = JSONDecoder.decodeFromSnakeCase(type: Market.self, from: market)

                XCTAssertEqual(marketData?.pageNo, 1)
                XCTAssertEqual(marketData?.lastPage, 114)
            case .failure(_):
                XCTFail("fetchData failure")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_mockURLSession_failure() {
        // when: MockURLSession 호출결과가 실패일 때
        sut = MarketURLSessionProvider(session: MockURLSession(isRequestFail: true))
        
        // then: MockURLSession을 통해 테스트
        let expectation = XCTestExpectation()
        
        guard let url = URL(string: "url") else { return }
        
        sut.fetchData(request: URLRequest(url: url)) { result in
            switch result {
            case .success(_):
                XCTFail("result is success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription,
                               NetworkError.httpResponseError(code: 410).localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
