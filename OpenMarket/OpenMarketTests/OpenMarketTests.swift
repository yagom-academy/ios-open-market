//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 이성노 on 2021/05/13.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_JSON데이터가_JSONParser에_Decoding_돼서_id의_값이_1인지확인해보는_함수() {
        var jsonParser = JSONParser<Item>()
        
        jsonParser.parse(assetName: "Item")
        
        guard let data: Item = jsonParser.convertedData else { return }
        
        XCTAssertEqual(data.id, 1)
    }
}
