//
//  URLSessionTests.swift
//  URLSessionTests
//
//  Created by song on 2022/05/12.
//

import XCTest
@testable import OpenMarket

class URLHealthCheckerSessionTests: XCTestCase {

    var sut: URLSessionProvider<String>!
    override func setUpWithError() throws {
        sut = URLSessionProvider()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_path가_healthChecker일때_getUser_메서드를_호출하면_data의_값이_OK인지() {
        //given
        let promise = expectation(description: "data value is OK")
       
        //when
        sut.getData(from: .healthChecker) { result in
            //then
            switch result {
            case .success(let data):
                XCTAssertEqual(data, "OK")
            case .failure(_):
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
}
