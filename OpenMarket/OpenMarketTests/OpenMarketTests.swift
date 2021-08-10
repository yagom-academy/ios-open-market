//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by KimJaeYoun on 2021/08/10.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    //데이터
    //테스트 item, items 각각 파싱 되는지
    func test_OpenMarketItems의_페이지가_1이다() {
        //given
        let assetData = NSDataAsset(name: "Items")!
        //when
        let decodedData = try! JSONDecoder().decode(OpenMarketItems.self, from: assetData.data)
        //then
        XCTAssertEqual(decodedData.page, 1)
    }
}
