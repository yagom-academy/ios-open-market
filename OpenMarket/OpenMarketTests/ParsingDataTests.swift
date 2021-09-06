//
//  ParsingDataTests.swift
//  OpenMarketTests
//
//  Created by 박태현 on 2021/09/06.
//

import XCTest
@testable import OpenMarket

class ParsingDataTests: XCTestCase {
    var sut: CustomJSONDecoder!

    override func setUpWithError() throws {
        sut = CustomJSONDecoder()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_parsingItemWithMockData_success() {
        // give
        let testTarget = "MockItem"

        guard let json = try? CustomJSONDecoder.fetchFromAssets(assetName: testTarget) else {
            return XCTFail("json 파일을 찾을 수 없습니다.")
        }
        // when
        guard let decodedData = try? CustomJSONDecoder().decode(Item.self, from: json.data) else {
            return XCTFail("decoding에 실패했습니다.")
        }
        let result = decodedData.title
        let expectResult = "MacBook Pro"
        // then
        XCTAssertEqual(result, expectResult)
    }

    func testModel_parsingItemsWithMockData_success() {
        // give
        let testTarget = "MockItems"

        guard let json = try? CustomJSONDecoder.fetchFromAssets(assetName: testTarget) else {
            return XCTFail("json 파일을 찾을 수 없습니다.")
        }
        // when
        guard let decodedData = try? CustomJSONDecoder().decode(Items.self, from: json.data) else {
            return XCTFail("decoding에 실패했습니다.")
        }
        let result = decodedData.page
        let expectResult = 1
        // then
        XCTAssertEqual(result, expectResult)
    }
}
