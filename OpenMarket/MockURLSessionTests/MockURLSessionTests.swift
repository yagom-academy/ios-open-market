//
//  MockURLSessionTests.swift
//  MockURLSessionTests
//
//  Created by 주디, 재재 on 2022/07/12.
//

import XCTest

@testable import OpenMarket

class MockURLSessionTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_receivePage_서버요청이_성공한경우에_받아온Json데이터가_MockData와같은지() {
        let mockURLSession = MockURLSession(isSuccess: true)
        let sut = URLSessionProvider(session: mockURLSession)
        
        guard let mockData = NSDataAsset.init(name: "MockData")?.data,
              let page = decodeMarket(type: Page.self, data: mockData) else { return }
        
        sut.receivePage(number: 1, countOfItems: 20) { result in
            switch result {
            case .success(let data):
                let responsedData = decodeMarket(type: Page.self, data: data)
                XCTAssertEqual(responsedData?.pageNumber, page.pageNumber)
                XCTAssertEqual(responsedData?.itemsPerPage, page.itemsPerPage)
            case .failure(_):
                XCTFail("서버 데이터 불일치 오류")
            }
        }
    }
    
    func test_receivePage_서버요청이_실패한경우에_에러를반환하는지() {
        let mockURLSession = MockURLSession(isSuccess: false)
        let sut = URLSessionProvider(session: mockURLSession)
        
        sut.receivePage(number: 1, countOfItems: 20) { result in
            switch result {
            case .success(_):
                XCTFail("서버 요청이 실패하지 않은 오류")
            case .failure(let error):
                XCTAssertEqual(error, DataTaskError.incorrectResponseError)
            }
        }
    }
}
