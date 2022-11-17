//
//  StubURLSessionTest.swift
//  OpenMarketTests
//
//  Created by 김인호 on 2022/11/17.
//

import XCTest
@testable import OpenMarket

class StubURLSessionTest: XCTestCase {
    var sut: NetworkManager!
    var stubUrlSession: StubURLSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
        stubUrlSession = StubURLSession()
        sut = NetworkManager(session: stubUrlSession)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        stubUrlSession = nil
        sut = nil
    }
    
    func test_healtChecker를_요청할때_OK를리턴해야한다() {
        //given
        guard let url = NetworkRequest.healthCheck.url else { return }
        
        let expectedData = "\"OK\"".data(using: .utf8)
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let dummyData = DummyData(data: expectedData,
                                  response: response,
                                  error: nil)
        stubUrlSession.dummyData = dummyData
        
        //when
        sut.loadData(of: NetworkRequest.healthCheck,
                     dataType: String.self) { result in
            switch result {
            case .success(let text):
                //then
                XCTAssertEqual(text, "OK")
            case .failure(let error):
                XCTFail("loadData failure: \(error)")
            }
        }
    }
    
    func test_productListData를받았을때_전달받은값을_리턴해야한다() {
        //given
        guard let url = NetworkRequest.productList.url else { return }
        
        let expectedData = """
                        {
                            "pageNo": 1,
                            "itemsPerPage": 10,
                            "totalCount": 116,
                            "offset": 0,
                            "limit": 10,
                            "lastPage": 12,
                            "hasNext": true,
                            "hasPrev": false,
                            "pages": []
                        }
                        """.data(using: .utf8)
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let dummyData = DummyData(data: expectedData,
                                  response: response,
                                  error: nil)
        stubUrlSession.dummyData = dummyData
        
        //when
        sut.loadData(of: NetworkRequest.productList,
                     dataType: ProductListData.self) { result in
            switch result {
            case .success(let productListData):
                //then
                XCTAssertEqual(productListData.totalCount, 116)
            case .failure(let error):
                XCTFail("loadData failure: \(error)")
            }
        }
    }
    
    func test_productData를받았을때_전달받은값을_리턴해야한다() {
        guard let url = NetworkRequest.product.url else { return }
        
        let expectedData = """
                        {
                            "id": 197,
                            "vendor_id": 13,
                            "vendorName": "mimm123",
                            "name": "Test",
                            "description": "11111111111111",
                            "thumbnail": "https://training-resources/13/20221116.jpeg",
                            "currency": "KRW",
                            "price": 11111.0,
                            "bargain_price": 10000.0,
                            "discounted_price": 1111.0,
                            "stock": 11,
                            "created_at": "2022-11-16T00:00:00",
                            "issued_at": "2022-11-16T00:00:00"
                        }
                        """.data(using: .utf8)
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let dummyData = DummyData(data: expectedData,
                                  response: response,
                                  error: nil)
        stubUrlSession.dummyData = dummyData
        
        //when
        sut.loadData(of: .product, dataType: ProductData.self) { result in
            switch result {
            case .success(let productData):
                //then
                XCTAssertEqual(productData.vendorName, "mimm123")
            case .failure(let error):
                XCTFail("loadData failure: \(error)")
            }
        }
    }
    
    func test_response의statusCode가_서버오류를나타낼때_데이터를가져오는데_실패해야한다() {
        guard let url = NetworkRequest.productList.url else { return }
        
        let expectedData = """
                        {
                            "id": 197,
                            "vendor_id": 13,
                            "vendorName": "mimm123",
                            "name": "Test",
                            "description": "11111111111111",
                            "thumbnail": "https://training-resources/13/20221116.jpeg",
                            "currency": "KRW",
                            "price": 11111.0,
                            "bargain_price": 10000.0,
                            "discounted_price": 1111.0,
                            "stock": 11,
                            "created_at": "2022-11-16T00:00:00",
                            "issued_at": "2022-11-16T00:00:00"
                        }
                        """.data(using: .utf8)
        let response = HTTPURLResponse(url: url,
                                       statusCode: 501,
                                       httpVersion: nil,
                                       headerFields: nil)
        let dummyData = DummyData(data: expectedData,
                                  response: response,
                                  error: nil)
        stubUrlSession.dummyData = dummyData
        
        sut.loadData(of: .product, dataType: ProductData.self) { result in
            switch result {
            case .success(let productData):
                //then
                XCTAssertNotEqual(productData.vendorName, "notAVendor")
            case .failure(let error):
                XCTAssertEqual(OpenMarketError.serverError, error as? OpenMarketError)
            }
        }
    }
}
