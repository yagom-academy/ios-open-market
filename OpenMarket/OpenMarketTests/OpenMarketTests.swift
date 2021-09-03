//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 이윤주 on 2021/09/03.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    func test_success_JSON파일인Item을_Item타입에디코딩하면_title은MacBookPro다() {
        //given
        let path = Bundle(for: type(of: self)).path(forResource: "Item", ofType: "json")
        let jsonFile = try? String(contentsOfFile: path!).data(using: .utf8)
        var outputValue: String?
        //when
        let data = ParsingManager().parse(jsonFile!, to: Item.self)
        switch data {
        case .success(let item):
            outputValue = item.title
        case .failure(let error):
            XCTFail()
        }
        let expectedResultValue = "MacBook Pro"
        //then
        XCTAssertEqual(outputValue, expectedResultValue)
    }
}
