//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by kio on 2021/05/31.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    var sut = NetworkManger!
    sut: MockURLSession
    
    func test_getData_AssetData() {
        let expectation = XCTestExpectation()
        let response = try? JSONDecoder().decode(ItemPage.self,
                                                 from: NSDataAsset(name: "Items")!.data)
         
        NetworkManger.get { result in
            switch result {
            case .success(let joke):
                XCTAssertEqual(joke.id, response?.value.id)
                XCTAssertEqual(joke.joke, response?.value.joke)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
}

