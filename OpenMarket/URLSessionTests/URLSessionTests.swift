//
//  MockURLSessionTests.swift
//  MockURLSessionTests
//
//  Created by 주디, 재재 on 2022/07/12.
//

import XCTest

@testable import OpenMarket

class URLSessionTests: XCTestCase {
    var sut: URLSessionProvider!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSessionProvider(session: URLSession.shared)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_receivePage_실제로서버요청을했을때_2번페이지데이터를_받아올수있는지() {
        sut.receivePage(number: 2, countOfItems: 10) { result in
            switch result {
            case .success(let data):
                let responsedData = decodeMarket(type: Page.self, data: data)
                XCTAssertEqual(responsedData?.totalCount, 325)
            case .failure(_):
                XCTFail("서버 데이터 불일치 오류")
            }
        }
    }
}
