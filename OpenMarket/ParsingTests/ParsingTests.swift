//
//  ParsingTests.swift
//  ParsingTests
//
//  Created by Mangdi on 2022/11/15.
//

import XCTest
@testable import OpenMarket

class ParsingTests: XCTestCase {
    var sut: TestJsonProducts?

    override func setUpWithError() throws {
        try super.setUpWithError()
        let jsonDecoder = JSONDecoder()
        sut = jsonDecoder.decodeData("step1_testdata")
        
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_Products에_값이잘들어왔는지() {
        XCTAssertNotNil(sut)
    }
    
    func test_Products의_요소들이_잘들어왔는지() {
        XCTAssertEqual(sut?.pageNumber, 1)
        XCTAssertEqual(sut?.itemsPerPage, 20)
        XCTAssertEqual(sut?.totalCount, 10)
        XCTAssertEqual(sut?.offset, 0)
        XCTAssertEqual(sut?.limit, 20)
        XCTAssertEqual(sut?.lastPage, 1)
        XCTAssertEqual(sut?.hasNext, false)
        XCTAssertEqual(sut?.hasPrevious, false)
    }
    
    func test_Pages에_값이잘들어있는지() {
        XCTAssertNotNil(sut?.pages)
    }
    
    func test_Products의_pages첫번째배열_의값이잘들어있는지() {
        XCTAssertEqual(sut?.pages[0].id, 20)
        XCTAssertEqual(sut?.pages[0].vendorID, 3)
        XCTAssertEqual(sut?.pages[0].name, "Test Product")
        XCTAssertEqual(sut?.pages[0].thumbnail, "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/5a0cd56b6d3411ecabfa97fd953cf965.jpg")
        XCTAssertEqual(sut?.pages[0].currency, "KRW")
        XCTAssertEqual(sut?.pages[0].price, 0)
        XCTAssertEqual(sut?.pages[0].bargainPrice, 0)
        XCTAssertEqual(sut?.pages[0].discountedPrice, 0)
        XCTAssertEqual(sut?.pages[0].stock, 0)
        XCTAssertEqual(sut?.pages[0].createdAt, "2022-01-04T00:00:00.00")
        XCTAssertEqual(sut?.pages[0].issuedAt, "2022-01-04T00:00:00.00")
    }
}
