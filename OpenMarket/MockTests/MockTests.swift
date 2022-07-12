//
//  MockTests.swift
//  MockTests
//
//  Created by 케이, 수꿍 on 2022/07/11.
//

import XCTest
@testable import OpenMarket

class MockTests: XCTestCase {
    var sut: URLData!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }

    override func tearDownWithError() throws {
        try super.setUpWithError()
        sut = nil
    }
    
    func test_fetchData_메서드가_status_code가_200일때_mock_data를_예상한_값과_동일하게_가져오는지_테스트() throws {
        // given
        let expectation: WebPage? = JSONData.decode(fileName: "Mock", fileExtension: "json", dataType: WebPage.self)
        
        let url = "https://market-training.yagom-academy.kr/"
        let mockResponse: MockURLSession.Response = {
            let data = JSONData.parse(fileName: "Mock", fileExtension: "json")
            let successResponse = HTTPURLResponse(url: URL(string: url)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (data: data, urlResponse: successResponse, error: nil)
        }()
        
        var result: WebPage?
        let mockURLSession = MockURLSession(response: mockResponse)
        let sut = URLData(session: mockURLSession)
        
        // when
        sut.fetchData(url: URL(string: url)!, dataType: WebPage.self) { response in
            if case let .success(market) = response {
                result = market
            }
        }
        
        // then
        XCTAssertEqual(expectation?.pages.count, result?.pages.count)
    }
    
    func test_fetchData_메서드가_status_code가_500일때_mock_data를_가져오는데_실패하는지_테스트() throws {
        // given
        let expectation: WebPage? = JSONData.decode(fileName: "Mock", fileExtension: "json", dataType: WebPage.self)
        
        let url = "https://market-training.yagom-academy.kr/"
        let mockResponse: MockURLSession.Response = {
            let data = JSONData.parse(fileName: "Mock", fileExtension: "json")
            let successResponse = HTTPURLResponse(url: URL(string: url)!, statusCode: 500, httpVersion: nil, headerFields: nil)
            return (data: data, urlResponse: successResponse, error: nil)
        }()
        
        var result: WebPage?
        let mockURLSession = MockURLSession(response: mockResponse)
        let sut = URLData(session: mockURLSession)
        
        // when
        sut.fetchData(url: URL(string: url)!, dataType: WebPage.self) { response in
            if case let .success(market) = response {
                result = market
            }
        }
        
        // then
        XCTAssertNotEqual(expectation?.pages.count, result?.pages.count)
    }
}
