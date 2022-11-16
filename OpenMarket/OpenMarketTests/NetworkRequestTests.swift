//
//  NetworkRequestTests.swift
//  OpenMarketTests
//
//  Created by Gundy, Wonbi on 2022/11/16.
//

import XCTest
@testable import OpenMarket

final class NetworkRequestTests: XCTestCase {
    var sut: NetworkRequest!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = .none
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }
    
    func test_HealthCheckerRequest의_urlComponents가_정상적으로반환되는지() {
        // given
        sut = HealthCheckerRequest()
        
        // when
        let result = sut.urlComponents
        
        // then
        let expectation: URL? = .init(string: "https://openmarket.yagom-academy.kr/healthChecker?")
        XCTAssertEqual(result, expectation)
    }
}
