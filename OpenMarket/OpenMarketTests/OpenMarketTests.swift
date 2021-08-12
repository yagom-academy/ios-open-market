//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by JINHONG AN on 2021/08/12.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    
    func test_Item에셋파일을_Product타입으로디코딩을하면_타이틀은맥북프로이다() {
        //Given
        let expectInputValue = "Item"
        //When
        let parsedResult = ParsingManager().decode(from: expectInputValue, to: Product.self)
        guard case .success(let outputValue) = parsedResult else {
            return XCTFail()
        }
        let expectResultValue = "MacBook Pro"
        //Then
        XCTAssertEqual(outputValue.title, expectResultValue)
    }
}
