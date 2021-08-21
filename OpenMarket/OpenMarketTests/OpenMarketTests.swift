//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Kim Do hyung on 2021/08/10.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    
    let parsingManger = ParsingManager()
    let decoder = JSONDecoder()
    
    override func setUp() {
        super.setUp()
    }
    
    func test_Item_Json파일을_decoding했을때_title이_MacBook_Pro이다() {
        //given
        guard let assetData = NSDataAsset.init(name: "Item") else { return }
        //when
        let productData = parsingManger.decodingData(data: assetData.data, model: Product.self)
        let result = productData?.title
        let expectedResult = "MacBook Pro"
        //then
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_Items_Json파일을_decoding했을때_첫번째_item_price가_1690이다() {
        //given
        guard let assetData = NSDataAsset.init(name: "Items") else { return }
        //when
        let pageData = parsingManger.decodingData(data: assetData.data, model: Page.self)
        let result = pageData?.products.first?.price
        let expectedResult = 1690
        //then
        XCTAssertEqual(result, expectedResult)
    }
}
