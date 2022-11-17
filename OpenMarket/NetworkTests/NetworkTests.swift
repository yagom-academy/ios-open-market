//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by jin on 11/17/22.
//

import XCTest
@testable import OpenMarket

final class NetworkTests: XCTestCase {
    
    var sut: NetworkAPIProvider!
    
    override func setUpWithError() throws {
        sut = .init(session: MockURLSession())
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_fetchRandomJoke() {
//        let expectation = XCTestExpectation()
        guard let assetData = NSDataAsset.init(name: "products") else {
            return
        }
        
        let response = try? JSONDecoder().decode(ProductList.self,
                                                 from: assetData.data)
        
        sut.fetchProductList(query: nil) { result in
            print(result.itemsPerPage)
            print(response?.hasNext)
            XCTAssertEqual(result.pageNumber, response?.pageNumber)
            XCTAssertEqual(result.itemsPerPage, response?.itemsPerPage)
//            expectation.fulfill()
        }
        sleep(5)
//        wait(for: [expectation], timeout: 10.0)
    }
    
}
