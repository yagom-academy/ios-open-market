//
//  ParsingTests.swift
//  ParsingTests
//
//  Created by groot, bard on 2022/07/12.
//

import XCTest
@testable import OpenMarket

final class ParsingTests: XCTestCase {
    var mockData: NSDataAsset!
    var jsonDecoder: JSONDecoder!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockData = NSDataAsset(name: "MockData")
        jsonDecoder = JSONDecoder()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockData = nil
        jsonDecoder = nil
    }
    
    func test_목데이터디코딩이_잘되는지() {
        // given
        let data = (mockData?.data)!
        let openMaketData = try? jsonDecoder.decode(ProductsList.self, from: data)
        
        // when
        let result = "Test Product"
        
        // then
        XCTAssertEqual(result, openMaketData!.pages[2].name)
    }
}
