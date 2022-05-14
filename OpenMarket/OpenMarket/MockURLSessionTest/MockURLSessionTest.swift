//
//  URLSessionTest.swift
//  URLSessionTest
//
//  Created by song on 2022/05/12.
//

import XCTest
@testable import OpenMarket

class MockURLSessionTest: XCTestCase {
    var sut: URLSessionProvider<ProductCatalog>!
    
    override func setUpWithError() throws {
        let session = MockURLSession()
        sut = URLSessionProvider<ProductCatalog>(session: session)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_네트워크가_연결이_되지않아도_getData의_함수를_호출하면_Mock데이터의_itemspPerPage의_값이_20인지() {
        //given
        let promise = expectation(description: "The Value of items per page 20")
        
        //when
        sut.getData(from: .healthChecker) { result in
            //then
            switch result {
            case .success(let data):
                XCTAssertEqual(data.itemsPerPage, 20)
            case .failure(_):
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
    
    func test_네트워크가_연결이_되지않아도_getData의_함수를_호출하면_Mock데이터의_totalCount의_값이_10인지() {
        //given
        let promise = expectation(description: "The value of the totalCount is 10")
        
        //when
        sut.getData(from: .healthChecker) { result in
            //then
            switch result {
            case .success(let data):
                XCTAssertEqual(data.totalCount, 10)
            case .failure(_):
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
    
    func test_네트워크가_연결이_되지않아도_getData의_함수를_호출하면_Mock데이터의_pages의_첫번째값의_id값이_20인지() {
        //given
        let promise = expectation(description: "The first value of pages is 20")
        
        //when
        sut.getData(from: .healthChecker) { result in
            //then
            switch result {
            case .success(let data):
                XCTAssertEqual(data.pages?.first?.id, 20)
            case .failure(_):
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
}
