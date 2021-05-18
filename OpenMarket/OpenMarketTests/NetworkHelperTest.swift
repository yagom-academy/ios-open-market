//
//  NetworkHelperTest.swift
//  OpenMarketTests
//
//  Created by steven on 2021/05/18.
//

import XCTest

@testable import OpenMarket
class NetworkHelperTest: XCTestCase { 

    func test_요청_url_생성() {
        XCTAssertEqual(RequestAddress.createItem.url, "")
    }
    
    func test_상품_목록_요청() {
        let networkHelper = NetworkHelper()
        let pageNum = 10
        
        networkHelper.readList(pageNum: pageNum) { result in
            switch result {
            case .success(let itemsList):
                XCTAssertEqual(itemsList.items.count, 20)
            case .failure:
                XCTFail()
            }
        }
    }

}
