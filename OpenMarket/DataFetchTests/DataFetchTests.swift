//
//  DataFetchTests.swift
//  DataFetchTests
//
//  Created by 유한석 on 2022/07/11.
//
import XCTest

class DataFetchTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_decodeJsonData가_리턴이_nil이아님을테스트() throws {
        //given
        //when
        let result: ProductPage? = decodeJsonData()
        //then
        XCTAssertNotNil(result)
    }
}
