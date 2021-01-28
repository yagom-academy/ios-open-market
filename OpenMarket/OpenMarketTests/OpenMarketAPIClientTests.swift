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

    override func tearDownWithError() throws {
        sut = nil
    }

    func testRequestMarketItem() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(sampleData: OpenMarketAPI.requestMarketItem.sampleData))
        let expectation = XCTestExpectation()
        let mock = try? JSONDecoder().decode(MarketItem.self, from: OpenMarketAPI.requestMarketItem.sampleData)
        
        sut.requestMarketItem(id: 1) { result in
            switch result {
            case .success(let marketItem):
                XCTAssertEqual(marketItem.id, mock?.id)
                XCTAssertEqual(marketItem.title, mock?.title)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testRequestMarketItem_failure() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(makeRequestFail: true, sampleData: OpenMarketAPI.requestMarketItem.sampleData))
        let expectation = XCTestExpectation()
        
        sut.requestMarketItem(id: 1) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, OpenMarketAPIError.networkError)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testRequestMarketPage() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(sampleData: OpenMarketAPI.requestMarketPage.sampleData))
        let expectation = XCTestExpectation()
        let mock = try? JSONDecoder().decode(MarketPage.self, from: OpenMarketAPI.requestMarketPage.sampleData)
        
        sut.requestMarketPage(pageNumber: 1) { result in
            switch result {
            case .success(let marketPage):
                XCTAssertEqual(marketPage.pageNumber, mock?.pageNumber)
                XCTAssertEqual(marketPage.marketItems[0].id, marketPage.marketItems[0].id)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testRequestMarketPage_failure() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(makeRequestFail: true, sampleData: OpenMarketAPI.requestMarketPage.sampleData))
        let expectation = XCTestExpectation()
        
        sut.requestMarketPage(pageNumber: 1) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, OpenMarketAPIError.networkError)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
}
