//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Dasoll Park on 2021/08/11.
//

import XCTest

@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    var sutNetworkManager: NetworkManager?
    let expectationDescription = "Download complete."

    override func setUpWithError() throws {
        sutNetworkManager = NetworkManager(session: MockURLSession())
    }

    override func tearDownWithError() throws {
        sutNetworkManager = nil
    }
    
    func test_빈데이터를생성해서_parse하면_failToDecode에러를던진다() {
        // given
        let testDataType = Page.self
        let testData = Data()
        let expectedError = NetworkError.failToDecode
        
        // when
        let result = testData.parse(type: testDataType)

        // then
        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? NetworkError, expectedError)
        default:
            XCTFail()
        }
    }
    
    func test_Item파일을parse하면_title이MacBookPro다() throws {
        // given
        let testFileName = MockURL.mockItem.description
        let testDataType = Item.self
        let testData = try XCTUnwrap(NSDataAsset(name: testFileName)?.data)
        let expectedValue = "MacBook Pro"
        
        // when
        let result = testData.parse(type: testDataType)
        
        // then
        switch result {
        case .success(let data):
            XCTAssertEqual(data.title, expectedValue)
        default:
            XCTFail()
        }
    }
    
    func test_Items파일을parse하면_8번인덱스Item의title이AppleWatchSeries6다() throws {
        // given
        let testFileName = MockURL.mockItems.description
        let testDataType = Page.self
        let testData = try XCTUnwrap(NSDataAsset(name: testFileName)?.data)
        let index = 8
        let expectedValue = "Apple Watch Series 6"
        
        // when
        let result = testData.parse(type: testDataType)
        
        // then
        switch result {
        case .success(let data):
            XCTAssertEqual(data.items[index].title, expectedValue)
        default:
            XCTFail()
        }
    }
    
    func test_items슬래시1URL을_fetchData에넣으면_2번인덱스Item의title이Macmini다() throws {
        // given
        let urlString = MockURL.mockItems.description
        let url = try XCTUnwrap(URL(string: urlString))
        let index = 2
        var outcome: String?
        let expectation = XCTestExpectation(description: expectationDescription)
        let expectedValue = "Mac mini"
        
        // when
        sutNetworkManager?.fetchData(url: url) { (result: Result<Page, Error>) in
            switch result {
            case .success(let data):
                outcome = data.items[index].title
            default:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        // thenss
        XCTAssertEqual(outcome, expectedValue)
    }
    
    func test_item슬래시1URL을_fetchData에넣으면_title이MacBookPro다() throws {
        // given
        let urlString = MockURL.mockItem.description
        let url = try XCTUnwrap(URL(string: urlString))
        var outcome: String?
        let expectation = XCTestExpectation(description: expectationDescription)
        let expectedValue = "MacBook Pro"
        
        // when
        sutNetworkManager?.fetchData(url: url) { (result: Result<Item, Error>) in
            switch result {
            case .success(let data):
                outcome = data.title
            default:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        // then
        XCTAssertEqual(outcome, expectedValue)
    }
    
    func test_잘못된URL을_fetchData에넣으면_에러가발생한다() throws {
        // given
        let urlString = "https://apple.com"
        let url = try XCTUnwrap(URL(string: urlString))
        let expectedError = NetworkError.invalidResponse
        var outcome: NetworkError?
        let expectation = XCTestExpectation(description: expectationDescription)
        
        // when
        sutNetworkManager?.fetchData(url: url) { (result: Result<Page, Error>) in
            switch result {
            case .failure(let error):
                outcome = error as? NetworkError
            default:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        // then
        XCTAssertEqual(outcome, expectedError)
    }
}
