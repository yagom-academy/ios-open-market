//
//  NetworkUnitTest.swift
//  NetworkUnitTest
//
//  Created by Baemini on 2022/11/15.
//

import XCTest
@testable import OpenMarket

class NetworkUnitTest: XCTestCase {
    let decoder = JSONDecoder()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func test_없는_파일을_디코딩_하려고하는_경우_Nil을_반환하는가() {
        //given
        let decode = NSDataAsset(name: "example")

        //when
        let data = try? decoder.decode(ProductListResponse.self, from: decode?.data ?? Data())
        
        //then
        XCTAssertNil(data)
    }
    
    func test_잘못된_타입으로_디코딩했을때_Nil을_반환하는가() {
        //given
        guard let decode = NSDataAsset(name: "products") else {
            XCTAssertThrowsError("Did Not Found File")
            return
        }

        //when
        let data = try? decoder.decode(Product.self, from: decode.data)
        
        //then
        XCTAssertNil(data)
    }
    
    func test_ProductData_Decoding_할_수_있는가() {
        //given
        guard let decode = NSDataAsset(name: "products") else {
            XCTAssertThrowsError("Did Not Found File")
            return
        }

        //when
        let data = try? decoder.decode(ProductListResponse.self, from: decode.data)
        
        //then
        XCTAssertNotNil(data)
    }
}
