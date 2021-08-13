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
        let expectedResult = NetworkError.failToDecode
        
        // when
        let result = sutParser?.parse(type: testDataType, data: testData)

        // then
        switch result {
        case .failure(let error):
            XCTAssertEqual(error as! NetworkError, expectedResult)
        default:
            XCTFail()
        }
    }
    
    func test_Item파일을parse하면_title이MacBookPro다() throws {
        // given
        let testDataType = Item.self
        let testData = try XCTUnwrap(NSDataAsset(name: "Item")?.data)
        let titleResult = "MacBook Pro"
        
        // when
        let result = sutParser?.parse(type: testDataType, data: testData)
        
        // then
        switch result {
        case .success(let data):
            XCTAssertEqual(data.title, titleResult)
        default:
            XCTFail()
        }
    }
    
    func test_Items파일을parse하면_8번째Item의title이AppleWatchSeries6다() throws {
        // given
        let testDataType = Page.self
        let testData = try XCTUnwrap(NSDataAsset(name: "Items")?.data)
        let titleResult = "Apple Watch Series 6"
        let index = 8
        
        // when
        let result = sutParser?.parse(type: testDataType, data: testData)
        
        // then
        switch result {
        case .success(let data):
            XCTAssertEqual(data.items[index].title, titleResult)
        default:
            XCTFail()
        }
    }
}
