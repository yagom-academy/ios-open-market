//
//  MockTests.swift
//  MockTests
//
//  Created by 케이, 수꿍 on 2022/07/11.
//

import XCTest
@testable import OpenMarket

class MockTests: XCTestCase {
    var sut: JSONData!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = JSONData()
    }

    override func tearDownWithError() throws {
        try super.setUpWithError()
        
        sut = nil
    }

    func test_parse_Mock_json_파일에서_마켓_타입을_정상적으로_가져오는지_테스트() throws {
        // given
        guard let market = sut.parse(fileName: "Mock", fileExtension: "json") else {
            return
        }
        
        // when
        let result = Market.self == type(of: market)
        
        // then
        XCTAssertTrue(result)
    }
    
    func test_parse_Mock_json_파일에서_추출한_pages의_각각의_id가_모두_추출되는지_테스트() throws {
        //given
        let expectation = [20, 19, 18, 17, 16, 15, 13, 4, 3, 2]
        
        // when
        guard let market = sut.parse(fileName: "Mock", fileExtension: "json") else {
            return
        }
        
        var result: [Int] = []
        
        market.pages.forEach {
            result.append($0.id)
        }
        
        // then
        XCTAssertEqual(expectation, result)
    }
}
