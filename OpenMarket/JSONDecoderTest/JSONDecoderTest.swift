//
//  ItemListTest.swift
//  ItemListTest
//
//  Created by Kiwi, Hugh on 2022/07/11.
//

import XCTest
@testable import OpenMarket

class JSONDecoderTest: XCTestCase {
    var itemList: ItemList!

    override func setUpWithError() throws {
        try super.setUpWithError()
        itemList = JSONDecoder.decodeJson(jsonName: "Products")
    }
    
    func test_Parsing을_통한_pageNumber의_반환값이_1인지확인() {
        // given
        let data = itemList.pageNumber
        
        // when
        let result = 1
        
        // then
        XCTAssertEqual(data, result)
    }
    
    func test_Parsing을_통한_Page타입의_첫번째_id_반환값이_20인지확인() {
        // given
        let data = itemList.pages[0].id
        
        // when
        let result = 20
        
        // then
        XCTAssertEqual(data, result)
    }
    
    func test_JSON파일의_이름이_다를때_nil을_반환하는지_확인() {
        // given
        let itemList: ItemList? = JSONDecoder.decodeJson(jsonName: "Item")
        
        // when, then
        XCTAssertNil(itemList)
    }
}
