//
//  APIModelTests.swift
//  OpenMarketTests
//
//  Created by duckbok on 2021/05/13.
//

import XCTest
@testable import OpenMarket

class APIModelTests: XCTestCase {
    let mockPageData: Data = NSDataAsset(name: "Page")!.data
    let mockItemData: Data = NSDataAsset(name: "Item")!.data

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    func test_RespondedPage가_잘_Decode된다() {
        XCTAssertNotNil(try? JSONDecoder().decode(ResponsedPage.self, from: mockPageData))
    }

    func test_RespondedItem가_잘_Decode된다() {
        XCTAssertNotNil(try? JSONDecoder().decode(ResponsedItem.self, from: mockItemData))
    }
}
