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
    
    func test_decoding이성공하면_sut와list의items의첫번째요소가일치한다() throws{
        let testId: Int = 1
        let testTitle: String = "MacBook Pro"
        let testPrice: Int = 1690
        let testCurrency: String = "USD"
        let testStock: Int = 0
        let testThumbnails: [String] = ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
        ]
        let testRegistrationDate: Double = 1611523563.7237701
        
        let product = Product(id: testId, title: testTitle, price: testPrice, currency: testCurrency, stock: testStock, discountedPrice: nil, thumbnails: testThumbnails, registrationDate: testRegistrationDate)
        sut = ProductListSearch(page: 1, items: [product])
        let url = Bundle.main.url(forResource: "Items", withExtension: "json")!
        data = try Data(contentsOf: url)
        let list = try! decoder.decode(ProductListSearch.self, from: data)
        
        XCTAssertEqual(list.items.first, sut.items.first)
    }
}
