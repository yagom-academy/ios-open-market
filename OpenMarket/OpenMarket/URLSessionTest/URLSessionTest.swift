//
//  URLSessionTest.swift
//  URLSessionTest
//
//  Created by song on 2022/05/12.
//

import XCTest
@testable import OpenMarket

class URLSessionTest: XCTestCase {
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
        let promise = expectation(description: "")
        let url = URL(string: "empty")!
        let requset = URLRequest(url: url)
        
        //when
        sut.getData(from: requset) { result in
            //then
            switch result {
            case .success(let data):
                XCTAssertEqual(data.itemspPerPage, 20)
            case .failure(_):
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
}
