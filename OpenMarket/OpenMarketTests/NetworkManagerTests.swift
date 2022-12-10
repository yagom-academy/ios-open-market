//  NetworkManagerTests.swift
//  OpenMarketTests
//  Created by SummerCat & Bella on 2022/11/15.

import XCTest
@testable import OpenMarket

final class NetworkManagerTests: XCTestCase {
    
    var sut: NetworkManager!
    
    func test_request_JSON데이터를_Product타입으로_decoding성공() {
        // given
        let jsonData = """
{
    "id": 215,
    "vendor_id": 1,
    "name": "호빵펀치",
    "description": "주먹딱대",
    "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/1/20221119/275fc09e67a311eda9179de0f903b0ce_thumb.jpeg",
    "currency": "KRW",
    "price": 100.0,
    "bargain_price": -200.0,
    "discounted_price": 300.0,
    "stock": 10,
    "created_at": "2022-11-19T00:00:00",
    "issued_at": "2022-11-19T00:00:00"
}
"""
        let expectedData = try? JSONDecoder().decode(Product.self, from: Data(jsonData.utf8))
        let expectedResponse = HTTPURLResponse(url: URL(string: "kakao")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let stubSession: URLSessionable =  StubURLSession(data: Data(jsonData.utf8), response: expectedResponse!, error: nil)
        sut = NetworkManager(session: stubSession)
        
        // when
		sut.fetchProductDetail(id: 215, completion: { result in
            // then
            switch result {
            case .success(let product):
                XCTAssertEqual(product, expectedData)
            case .failure(_):
                XCTFail()
            }
        })
    }
    
    func test_request_의도적인error_주입시_예상한error가_발생() {
     // given
        let testData = "bella"
        let expectedData = try? JSONDecoder().decode(Product.self, from: Data(testData.utf8))
        let expectedResponse = HTTPURLResponse(url: URL(string: "kakao")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let stubSession: URLSessionable =  StubURLSession(data: Data(testData.utf8), response: expectedResponse!, error: NetworkError.decodingError)
        sut = NetworkManager(session: stubSession)
        
        // when
        sut.fetchProductDetail(id: 215, completion: { result in
            // then
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.URLError)
            }
        })
    }
}
