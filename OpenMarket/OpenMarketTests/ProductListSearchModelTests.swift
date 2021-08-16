//
//  ProductListSearchModelTests.swift
//  OpenMarketTests
//
//  Created by Charlotte, Hosinging on 2021/08/13.
//

import XCTest
@testable import OpenMarket
class ProductListSearchModelTests: XCTestCase {

    var sut: ProductListSearch!
    var decoder: JSONDecoder!
    var data: Data!
    
    override func setUpWithError() throws {
        decoder = JSONDecoder()
    }

    override func tearDownWithError() throws {
        decoder = nil
        data = nil
        sut = nil
    }
    
    func test_ProductListSearch모델이_Codable을채택한다() {
        XCTAssertTrue((sut as Any) is Codable)
    }

    func test_decoding이성공하면_error를throw하지않는다() throws {
        let url = Bundle.main.url(forResource: "Items", withExtension: "json")!
        data = try Data(contentsOf: url)
        XCTAssertNoThrow(try decoder.decode(ProductListSearch.self, from: data))
    }

}
