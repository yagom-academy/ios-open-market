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
    
    func test_빈데이터를생성해서_parse하면_failToDecode에러를던진다() throws {
        // given
        let testDataType = Page.self
        let testData = Data()
        let expectedResult = NetworkError.failToDecode
        
        // when
        let result = sutParser?.parse(type: testDataType, data: testData)

        // then
        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error as! NetworkError, expectedResult)
        case .none:
            XCTFail()
        }
    }
}
