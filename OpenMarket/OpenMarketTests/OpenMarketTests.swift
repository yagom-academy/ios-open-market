//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 김동빈 on 2021/01/25.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    func testMakeItemsListURL() throws {
        // 1. given
        let expectResult = URL(string: "https://camp-open-market.herokuapp.com/items/1")
        
        // 2. when
        let url = try URLManager.makeURL(type: .itemsListPage(1))
        
        // 3. then
        XCTAssertEqual(url, expectResult, "Making URL is Failed")
    }
    
    func test() throws {
        let expectation = XCTestExpectation(description: "Wait Decoding")
        
        let image1 = UIImage(systemName: "pencil")!
        let image2 = UIImage(systemName: "trash")!
        
        let item = ItemToUpdate(title: "AAAAAAAAAAAAAAAAAAAA", descriptions: "AAAAAAAAAAAAAAAA", price: 2, currency: "KRW", stock: 10, discountedPrice: 1, images: [image1, image2], password: "0")
        
        APIManager.handleRequest(requestType: .post(itme: item)) { result in
            switch result {
            case .success(let data):
                dump(data)
            case .failure(let error):
                print(error)
                XCTFail("Failed")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 30)
    }
}
    
