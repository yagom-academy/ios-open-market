//
//  PageTests.swift
//  OpenMarketTests
//
//  Created by Ayaan, junho on 2022/11/14.
//

import XCTest

final class PageTests: XCTestCase {
    func test_GivenDataAsset_WhenDecode_ThenResultDoNotThrow() {
        // given
        let dataAsset: NSDataAsset = NSDataAsset(name: "products")!
        
        // when, then
        XCTAssertNoThrow(try JSONDecoder().decode(Page.self, from: dataAsset.data))
    }
    
    func test_GivenDataAsset_WhenDecode_ThenResultIsNotNil() {
        // given
        let dataAsset: NSDataAsset = NSDataAsset(name: "products")!
        
        // when
        let result: Page = try! JSONDecoder().decode(Page.self, from: dataAsset.data)
        
        // then
        XCTAssertNotNil(result)
    }
}
