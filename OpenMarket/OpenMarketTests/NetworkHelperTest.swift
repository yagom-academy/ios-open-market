//
//  NetworkHelperTest.swift
//  OpenMarketTests
//
//  Created by steven on 2021/05/18.
//

import XCTest

@testable import OpenMarket
class NetworkHelperTest: XCTestCase {
    
    func test_상품_목록_요청() {
        let networkHelper = NetworkHelper()
        let pageNum = 1
        
        networkHelper.readList(pageNum: pageNum) { result in
            switch result {
            case .success(let itemsList):
                XCTAssertEqual(itemsList.items.count, 20)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func test_상품_조회_요청_성공() {
        let networkHelper = NetworkHelper()
        let idNum = 43
        
        networkHelper.readItem(itemNum: idNum) { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(item.id, idNum)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func test_상품_조회_요청_실패() {
        let networkHelper = NetworkHelper()
        let idNum = 1
        
        networkHelper.readItem(itemNum: idNum) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure:
                XCTAssert(true)
            }
        }
    }
    
}
