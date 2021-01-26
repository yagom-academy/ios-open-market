//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 김태형 on 2021/01/25.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let productDecoder = OpenMarketAPIManager()
        let pause = XCTestExpectation(description: "wait")
        var productlist: ProductList?
        
        productDecoder.decodeFromAPI() { result in
            switch result {
            case .success(let data):
                productlist = data
            case .failure(let error):
                print(error)
            }
            pause.fulfill()
        }
        wait(for: [pause], timeout: 5)
        dump(productlist)
        
        XCTAssertNotNil(productlist)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
