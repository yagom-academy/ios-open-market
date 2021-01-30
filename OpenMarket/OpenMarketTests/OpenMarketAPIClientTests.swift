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
    
    func test_getMarketPage() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(sampleData: OpenMarketAPIConfiguration.sampleDataOfMarkePage))
        let expectation = XCTestExpectation()
        let mock = try? JSONDecoder().decode(MarketPage.self, from: OpenMarketAPIConfiguration.sampleDataOfMarkePage)
        
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
    
    func test_getMarketPage_failure() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(makeRequestFail: true, sampleData: OpenMarketAPIConfiguration.sampleDataOfMarkePage))
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
    
    func test_postMarketItem() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(sampleData: OpenMarketAPIConfiguration.sampleDataOfMarkeItem))
        let expectation = XCTestExpectation()
        let mock = try? JSONDecoder().decode(MarketItem.self, from: OpenMarketAPIConfiguration.sampleDataOfMarkeItem)
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
    
    func test_postMarketItem_failure() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(makeRequestFail: true, sampleData: OpenMarketAPIConfiguration.sampleDataOfMarkeItem))
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

    func test_getMarketItem() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(sampleData: OpenMarketAPIConfiguration.sampleDataOfMarkeItem))
        let expectation = XCTestExpectation()
        let mock = try? JSONDecoder().decode(MarketItem.self, from: OpenMarketAPIConfiguration.sampleDataOfMarkeItem)
        
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
    
    func test_getMarketItem_failure() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(makeRequestFail: true, sampleData: OpenMarketAPIConfiguration.sampleDataOfMarkeItem))
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
    
    func test_patchMarketItem() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(sampleData: OpenMarketAPIConfiguration.sampleDataOfMarkeItem))
        let expectation = XCTestExpectation()
        let mock = try? JSONDecoder().decode(MarketItem.self, from: OpenMarketAPIConfiguration.sampleDataOfMarkeItem)
        let marketItemForPatch = MarketItemForPatch(title: "testTitle", descriptions: "testDescription", price: 550, currency: "KRW", stock: 11, discountedPrice: 50, images: [Data](), password: "1234")
        
        sut.patchMarketItem(id: 1, marketItemForPatch) { result in
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
    
    func test_patchMarketItem_failure() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(makeRequestFail: true, sampleData: OpenMarketAPIConfiguration.sampleDataOfMarkeItem))
        let expectation = XCTestExpectation()
        let marketItemForPatch = MarketItemForPatch(title: "testTitle", descriptions: "testDescription", price: 550, currency: "KRW", stock: 11, discountedPrice: 50, images: [Data](), password: "1234")
        
        sut.patchMarketItem(id: 1, marketItemForPatch) { result in
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
    
    func test_deleteMarketItem() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(sampleData: OpenMarketAPIConfiguration.sampleDataOfMarketItemID))
        let expectation = XCTestExpectation()
        let mock = try? JSONDecoder().decode(MarketItem.self, from: OpenMarketAPIConfiguration.sampleDataOfMarketItemID)
        let marketItemForDelete = MarketItemForDelete(id: 1, password: "1234")
        
        sut.deleteMarketItem(id: 1, marketItemForDelete) { result in
            switch result {
            case .success(let marketItem):
                XCTAssertEqual(marketItem.id, mock?.id)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_deleteMarketItem_failure() {
        sut = OpenMarketAPIClient(urlSession: MockURLSession(makeRequestFail: true, sampleData: OpenMarketAPIConfiguration.sampleDataOfMarkeItem))
        let expectation = XCTestExpectation()
        let marketItemForDelete = MarketItemForDelete(id: 1, password: "1234")
        
        sut.deleteMarketItem(id: 1, marketItemForDelete) { result in
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
