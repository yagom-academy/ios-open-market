//
//  PageTests.swift
//  OpenMarketTests
//
//  Created by Ayaan, junho on 2022/11/14.
//

import XCTest

final class PageTests: XCTestCase {
    func test_주어진_dataAsset을_Page타입으로_decode하면_결과는_오류가발생하지않는다() {
        // given
        let dataAsset: NSDataAsset = NSDataAsset(name: "products")!
        
        // when, then
        XCTAssertNoThrow(try JSONDecoder().decode(Page.self, from: dataAsset.data))
    }
    
    func test_주어진_dataAsset을_Page타입으로_decode한_경우_결과의_data는_Product_Array타입과_같고_nil이_아니다() {
        // given
        let dataAsset: NSDataAsset = NSDataAsset(name: "products")!
        
        // when
        let result: Page = try! JSONDecoder().decode(Page.self, from: dataAsset.data)
        
        // then
        XCTAssertNotNil(result)
    }
}
