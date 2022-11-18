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
    var sut: NetworkManager<ProductListResponse>?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkManager<ProductListResponse>()
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
    
    func test_testable() {
        //given
        let promise = expectation(description: "시작")
        let data: Data? =  """
        {
            "pageNo": 1,
            "itemsPerPage": 1,
            "totalCount": 112,
            "offset": 0,
            "limit": 1,
            "lastPage": 112,
            "hasNext": true,
            "hasPrev": false,
            "pages": [
                {
                    "id": 208,
                    "vendor_id": 29,
                    "vendorName": "wongbing",
                    "name": "테스트",
                    "description": "Post테스트용",
                    "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/29/20221118/5d06f05766db11eda917a9d79f703efd_thumb.png",
                    "currency": "KRW",
                    "price": 1200.0,
                    "bargain_price": 1200.0,
                    "discounted_price": 0.0,
                    "stock": 3,
                    "created_at": "2022-11-18T00:00:00",
                    "issued_at": "2022-11-18T00:00:00"
                }
            ]
        }
        """.data(using: .utf8)
        let url = URL(string: "https://openmarket.yagom-academy.kr/api/products?items_per_page=1&page_no=1")!
        let response: HTTPURLResponse? = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let api = OpenMarketAPI.productsList(pageNumber: 1, rowCount: 1)
        let dummyData: DummyData = DummyData(data: data, response: response, error: nil)
        let stubURLSession = StubURLSession(dummy: dummyData)
        
        //when
        sut?.session = stubURLSession
        sut?.fetchData(endPoint: api) { _ in
            XCTAssertEqual(self.sut?.testData, dummyData.data)
            promise.fulfill()
        }
        
        
        wait(for: [promise], timeout: 10)
    }
}
