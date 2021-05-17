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

    func test_ItemJSON데이터가_JSONParser에_Decoding_돼서_thumbnails의_값을_확인하는함수() {
        var jsonParserItem = JSONParser<Item>()
        
        jsonParserItem.parse(assetName: "Item")
        
        guard let data: Item = jsonParserItem.convertedData else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(data.thumbnails, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
        ])
    }
    
    func test_ItemsJSON데이터가_JSONParser에_Decoding_돼서_page의_값이_1인지확인해보는_함수() {
        var jsonParserItems = JSONParser<Items>()
        
        jsonParserItems.parse(assetName: "Items")
        
        guard let datas: Items = jsonParserItems.convertedData else { return }
        
        XCTAssertEqual(datas.page, 1)
    }
}
