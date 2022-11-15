//
//  DecodeTests.swift
//  DecodeTests
//
//  Created by 써니쿠키, 메네 on 15/11/2022.
//

import XCTest
@testable import OpenMarket

class DecodeTests: XCTestCase {
    
    func test_decode_메서드작동확인_pages배열의_첫번째이름_정상디코딩확인() {
        guard let data = JSONDecoder.decode(type: Market.self, from: "testData") else { return }
        
        // when
        let result = "Test Product"
        
        // then
        XCTAssertEqual(result, data.pages.first?.name)
    }
    
    func test_decode_메서드작동확인_Market타입의_lastPage_정상디코딩확인() {
        guard let data = JSONDecoder.decode(type: Market.self, from: "testData") else { return }
        
        // when
        let result = 1
        
        // then
        XCTAssertEqual(result, data.lastPage)
    }
    
    func test_decode_메서드작동확인_pages배열의_마지막id_정상디코딩확인() {
        guard let data = JSONDecoder.decode(type: Market.self, from: "testData") else { return }
        
        // when
        let result = 2
        
        // then
        XCTAssertEqual(result, data.pages.last?.id)
    }
    
}
