//
//  URLSessionManagerTests.swift
//  OpenMarketTest
//
//  Created by 김찬우 on 2021/06/01.
//

import XCTest
@testable import OpenMarket

class URLSessionManagerTests: XCTestCase {
    func test_getServerData메서드에서_요청을보냈을때_convertedData에_원하는데이터가_저장되는가(){
        let expectation = XCTestExpectation()
        let clientRequest = GETRequest(page: 1, descriptionAboutMenu: .목록조회)
        let urlSessionManager = URLSessionManager<Items>(clientRequest: clientRequest)
        var a: Items?
        urlSessionManager.getServerData{ (convertedData: Items) in
            a = convertedData
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
        XCTAssertEqual(a?.page, 1)
    }
}
