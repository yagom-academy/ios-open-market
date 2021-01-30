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
    
    func testGetMarketPage() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(sampleData: OpenMarketAPI.getMarketPage.sampleData))
        let expectation = XCTestExpectation()
        let mock = try? JSONDecoder().decode(MarketPage.self, from: OpenMarketAPI.getMarketPage.sampleData)
        
        sut.getMarketPage(pageNumber: 1) { result in
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
    
    func testGetMarketPage_failure() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(makeRequestFail: true, sampleData: OpenMarketAPI.getMarketPage.sampleData))
        let expectation = XCTestExpectation()
        
        sut.getMarketPage(pageNumber: 1) { result in
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
    
    func testPostMarketItem() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(sampleData: OpenMarketAPI.postMarketItem.sampleData))
        let expectation = XCTestExpectation()
        let mock = try? JSONDecoder().decode(MarketItem.self, from: OpenMarketAPI.postMarketItem.sampleData)
        let marketItemForPost = MarketItemForPost(title: "testTitle", descriptions: "testDescription", price: 550, currency: "KRW", stock: 11, discountedPrice: 50, images: [Data](), password: "1234")
        
        sut.postMarketIem(marketItemForPost) { result in
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
    
    func testPostMarketItem_failure() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(makeRequestFail: true, sampleData: OpenMarketAPI.postMarketItem.sampleData))
        let expectation = XCTestExpectation()
        let marketItemForPost = MarketItemForPost(title: "testTitle", descriptions: "testDescription", price: 550, currency: "KRW", stock: 11, discountedPrice: 50, images: [Data](), password: "1234")
        
        sut.postMarketIem(marketItemForPost) { result in
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

    func testGetMarketItem() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(sampleData: OpenMarketAPI.getMarketItem.sampleData))
        let expectation = XCTestExpectation()
        let mock = try? JSONDecoder().decode(MarketItem.self, from: OpenMarketAPI.getMarketItem.sampleData)
        
        sut.getMarketItem(id: 1) { result in
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
    
    func testGetMarketItem_failure() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(makeRequestFail: true, sampleData: OpenMarketAPI.getMarketItem.sampleData))
        let expectation = XCTestExpectation()
        
        sut.getMarketItem(id: 1) { result in
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
    
    func testPatchMarketItem() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(sampleData: OpenMarketAPI.patchMarketItem(id: 1).sampleData))
        let expectation = XCTestExpectation()
        let mock = try? JSONDecoder().decode(MarketItem.self, from: OpenMarketAPI.patchMarketItem(id: 1).sampleData)
        let marketItemForPatch = MarketItemForPatch(title: "testTitle", descriptions: "testDescription", price: 550, currency: "KRW", stock: 11, discountedPrice: 50, images: [Data](), password: "1234")
        
        sut.patchMarketIem(id: 1, marketItemForPatch) { result in
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
    
    func testPatchMarketItem_failure() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(makeRequestFail: true, sampleData: OpenMarketAPI.patchMarketItem(id: 1).sampleData))
        let expectation = XCTestExpectation()
        let marketItemForPatch = MarketItemForPatch(title: "testTitle", descriptions: "testDescription", price: 550, currency: "KRW", stock: 11, discountedPrice: 50, images: [Data](), password: "1234")
        
        sut.patchMarketIem(id: 1, marketItemForPatch) { result in
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
