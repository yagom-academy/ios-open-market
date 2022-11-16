//
//  DecodeTests.swift
//  DecodeTests
//
//  Created by 써니쿠키, 메네 on 15/11/2022.
//

import XCTest
@testable import OpenMarket

class DecodeTests: XCTestCase {
    var sut: Data!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let asset = NSDataAsset(name: "testData")
        sut = asset?.data
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_decode_메서드작동확인_pages배열의_첫번째이름_정상디코딩확인() {
        guard let data = JSONDecoder.decodeFromSnakeCase(type: Market.self, from: sut) else {
            return
        }
        
        // when
        let result = "Test Product"
        
        // then
        XCTAssertEqual(result, data.pages.first?.name)
    }
    
    func test_decode_메서드작동확인_Market타입의_lastPage_정상디코딩확인() {
        guard let data = JSONDecoder.decodeFromSnakeCase(type: Market.self, from: sut) else {
            return
        }
        
        // when
        let result = 1
        
        // then
        XCTAssertEqual(result, data.lastPage)
    }
    
    func test_decode_메서드작동확인_pages배열의_마지막id_정상디코딩확인() {
        guard let data = JSONDecoder.decodeFromSnakeCase(type: Market.self, from: sut) else {
            return
        }
        
        // when
        let result = 2
        
        // then
        XCTAssertEqual(result, data.pages.last?.id)
    }
}
