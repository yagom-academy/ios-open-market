//
//  OpenMarketAPIClientTests.swift
//  OpenMarketTests
//
//  Created by Kyungmin Lee on 2021/01/28.
//

import XCTest
@testable import OpenMarket

class OpenMarketAPIClientTests: XCTestCase {
    var sut: OpenMarketAPIClient!
    
    override func setUpWithError() throws {
        sut = OpenMarketAPIClient(urlSession: MockURLSession())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testRequestMarketItem() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession())
        let expectation = XCTestExpectation()
        let mock = try? JSONDecoder().decode(MarketItem.self, from: OpenMarketAPI.requestMarketItem.sampleData)
        
        sut.requestMarketItem(id: 1) { result in
            switch result {
            case .success(let marketItem):
                XCTAssertEqual(marketItem.id, mock?.id)
                XCTAssertEqual(marketItem.title, mock?.title)
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testRequestMarketItem_failure() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(makeRequestFail: true))
        let expectation = XCTestExpectation()
        
        sut.requestMarketItem(id: 1) { result in
            switch result {
            case .success:
                XCTFail()
                break
            case .failure(let error):
                XCTAssertEqual(error as! OpenMarketAPIError, OpenMarketAPIError.unknownError)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
}
