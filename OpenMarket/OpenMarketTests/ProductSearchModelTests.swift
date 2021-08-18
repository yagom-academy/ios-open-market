//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Charlotte, Hosinging on 2021/08/11.
//

import XCTest
@testable import OpenMarket

class ProductSearchModelTests: XCTestCase {
    
    var sut: ProductSearch!
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
    
    func test_ProductSearch모델이_Codable을채택한다() {
        XCTAssertTrue((sut as Any) is Codable)
    }
    
    func test_decoding이성공하면_error를throw하지않는다() throws {
        let url = Bundle.main.url(forResource: "Item", withExtension: "json")!
        data = try Data(contentsOf: url)
        XCTAssertNoThrow(try decoder.decode(ProductSearch.self, from: data))
    }

    func test_decoding이성공하면_sut와item의값이일치한다() throws {
        let testId: Int = 1
        let testTitle: String = "MacBook Pro"
        let testDescription: String = "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다."
        let testPrice: Int = 1690000
        let testCurrency: String = "KRW"
        let testStock: Int = 1000000000000
        let testThumbnails: [String] = [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
        ]
        let testImages: [String] = [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
        ]
        let testRegistrationDate: Double = 1611523563.719116
        
        sut = ProductSearch(id: testId, title: testTitle, price: testPrice, currency: testCurrency, stock: testStock, discountedPrice: nil, thumbnails: testThumbnails, registrationDate: testRegistrationDate, descriptions: testDescription, images: testImages)
        
        let url = Bundle.main.url(forResource: "Item", withExtension: "json")!
        data = try Data(contentsOf: url)
        let item = try! decoder.decode(ProductSearch.self, from: data)
        XCTAssertEqual(item, sut)
    }
}
