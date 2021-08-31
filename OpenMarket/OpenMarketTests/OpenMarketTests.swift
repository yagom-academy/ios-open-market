//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by tae hoon park on 2021/08/31.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    var parsingManager: ParsingManager?
    
    override func setUp() {
        super.setUp()
        parsingManager = ParsingManager()
    }
    
    func test_ItemsData_타입으로_디코딩에_성공한다() {
        //given
        let expectInputValue = "Items"
        //when
        guard let jsonData = try? parsingManager?.receivedDataAsset(assetName: expectInputValue),
              let decodedData = try? parsingManager?.decodedJsonData(type: ItemsData.self, data: jsonData.data)
              else {
            return XCTFail()
        }
        let expectResult = "MacBook Pro"
        let result = decodedData.items.first?.title
        //then
        XCTAssertEqual(expectResult, result)
    }
}
