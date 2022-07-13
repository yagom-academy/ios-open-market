//
//  URLDataTests.swift
//  URLDataTests
//
//  Created by 케이, 수꿍 on 2022/07/13.
//

import XCTest
@testable import OpenMarket

class URLDataTests: XCTestCase {
    var sut: URLData!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }

    override func tearDownWithError() throws {
        try super.setUpWithError()
        sut = nil
    }
    
    func test_fetchData_메서드가_실제_홈페이지에서_data를_가져오는지_테스트() throws {
        // given
        let url = "https://market-training.yagom-academy.kr/api/products?page_no=1&items_per_page=10"
        var result: WebPage?
        let urlSession = URLSession.shared
        let sut = URLData(session: urlSession)
        let promise = expectation(description: "It makes random value")
        
        // when
        sut.fetchData(url: URL(string: url)!, dataType: WebPage.self) { response in
            if case let .success(market) = response {
                result = market
                // then
                XCTAssertNotNil(result)
            } else {
                // then
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }

}
