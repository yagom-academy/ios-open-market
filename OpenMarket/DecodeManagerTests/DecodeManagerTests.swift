//
//  DecodeManagerTests.swift
//  DecodeManagerTests
//
//  Created by Kyo, LJ on 2022/11/14.
//

import XCTest
@testable import OpenMarket

class DecodeManagerTests: XCTestCase {
    var sut: DecodeManager<ProductPage>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DecodeManager()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test_정상적으로_데이터가_decoding이_되는지_확인() {
        let data = sut.decodeJson(fileName: "products")
        var flag = false
        switch data {
        case .success:
            flag = true
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
        
        XCTAssertTrue(flag)
    }
    
    func test_데이터가_없는_경우_오류_확인() {
        let data = sut.decodeJson(fileName: "")
        
        switch data {
        case .success(let data):
            XCTFail("Expected to be a failure but got a success with \(data)")
        case .failure(let error):
            XCTAssertEqual(error, NetworkError.empty)
        }
    }
}

