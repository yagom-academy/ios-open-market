//
//  OpenMarketURLSessionTests.swift
//  OpenMarketURLSessionTests
//
//  Created by dhoney96 on 2022/07/12.
//

import XCTest
@testable import OpenMarket

class OpenMarketURLSessionTests: XCTestCase {
    var openMarketURLsession: OpenMarketURLSession!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        openMarketURLsession = .init()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getMethod함수의_파라미터에_입력한_pageNumber와_서버에서_받아온_pageNumber가_일치하는지_확인() {
        // given
        openMarketURLsession.getMethod(pageNumber: 2000, itemsPerPage: 10) { result in
            switch result {
            case .success(let data):
                let safeData: ItemList? = JSONDecoder.decodeJson(jsonData: data!)
                print(safeData!.pageNumber)
                XCTAssertEqual(1, safeData!.pageNumber)
            case .failure(.dataError):
                XCTFail("dataError")
            case .failure(.statusError):
                XCTFail("statusError")
            case .failure(.defaultError):
                XCTFail("defaultError")
            }
        }
    }
}
