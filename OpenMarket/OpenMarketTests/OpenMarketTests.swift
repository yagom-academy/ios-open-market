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
    var sutParser: JSONParser?

    override func setUpWithError() throws {
        sutNetworkManager = NetworkManager(session: MockURLSession(), parser: JSONParser())
        sutParser = JSONParser()
    }

    override func tearDownWithError() throws {
        sutNetworkManager = nil
        sutParser = nil
    }
    
    func test_빈데이터를생성해서_parse하면_failToDecode에러를던진다() {
        // given
        let testDataType = Page.self
        let testData = Data()
        let expectedError = NetworkError.failToDecode
        
        // when
        let result = sutParser?.parse(type: testDataType, data: testData)

        // then
        switch result {
        case .failure(let error):
            XCTAssertEqual(error as! NetworkError, expectedError)
        default:
            XCTFail()
        }
    }
    
    func test_Item파일을parse하면_title이MacBookPro다() throws {
        // given
        let testDataType = Item.self
        let testData = try XCTUnwrap(NSDataAsset(name: "Item")?.data)
        let expectedValue = "MacBook Pro"
        
        // when
        let result = sutParser?.parse(type: testDataType, data: testData)
        
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
        let testDataType = Page.self
        let testData = try XCTUnwrap(NSDataAsset(name: "Items")?.data)
        let expectedValue = "Apple Watch Series 6"
        let index = 8
        
        // when
        let result = sutParser?.parse(type: testDataType, data: testData)
        
        // then
        switch result {
        case .success(let data):
            XCTAssertEqual(data.items[index].title, expectedValue)
        default:
            XCTFail()
        }
    }
    
    func test_items슬래시1URL을_fetchData에넣으면_2번인덱스Item의title이MacMini다() throws {
        // given
        let urlString = MockURL.mockItems.description
        let url = try XCTUnwrap(URL(string: urlString))
        let expectedValue = "Mac mini"
        let index = 2
        var outcome: String?
        let expectation = XCTestExpectation(description: "Download completed.")
        
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
        
        // then
        XCTAssertEqual(expectedValue, outcome)
    }
}
