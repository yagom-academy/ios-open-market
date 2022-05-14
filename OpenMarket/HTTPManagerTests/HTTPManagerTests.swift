//
//  HTTPManagerTests.swift
//  HTTPManagerTests
//
//  Created by papri, Tiana on 13/05/2022.
//

import XCTest
@testable import OpenMarket

class HTTPManagerTests: XCTestCase {
    var httpManager: HTTPManager!
    let dummyProductListData = """
    {
        "pages": [
            {
            "id": 20,
            "vendor_id": 3,
            "name": "Test Product",
            "thumbnail":    "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/5a0cd56b6d3411ecabfa97fd953cf965.jpg",
            "currency": "KRW",
            "price": 0,
            "bargain_price": 0,
            "discounted_price": 0,
            "stock": 0,
            "created_at": "2022-01-04T00:00:00.00",
            "issued_at": "2022-01-04T00:00:00.00"
            }
        ]
    }
    """.data(using: .utf8)!
    
    let dummyProductDetailData = """
        {
          "id": 522,
          "vendor_id": 6,
          "name": "아이폰13",
          "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/6/thumb/f9aa6e0d787711ecabfa3f1efeb4842b.jpg",
          "currency": "KRW",
          "price": 1300000,
          "description": "비싸",
          "bargain_price": 1300000,
          "discounted_price": 0,
          "stock": 12,
          "created_at": "2022-01-18T00:00:00.00",
          "issued_at": "2022-01-18T00:00:00.00",
          "images": [
            {
              "id": 352,
              "url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/6/origin/f9aa6e0d787711ecabfa3f1efeb4842b.jpg",
              "thumbnail_url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/6/thumb/f9aa6e0d787711ecabfa3f1efeb4842b.jpg",
              "succeed": true,
              "issued_at": "2022-01-18T00:00:00.00"
            }
          ],
          "vendors": {
            "name": "제인",
            "id": 6,
            "created_at": "2022-01-10T00:00:00.00",
            "issued_at": "2022-01-10T00:00:00.00"
          }
        }
        """.data(using: .utf8)!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        httpManager = HTTPManager(hostURL: "https://market-training.yagom-academy.kr/", urlSession: urlSession)
    }
    
    func test_listenHealthChecker_호출하면_StatusCode가_200인지_확인() {
        // given
        MockURLProtocol.requestHandler = {request in
            let exampleData = self.dummyProductListData
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, exampleData)
        }
        
        let expectation = XCTestExpectation(description: "It gives StatusCode 200")
        
        //when
        httpManager.listenHealthChecker { response in
            switch response {
            case .success(let response):
                
                // then
                XCTAssertEqual(response.statusCode, 200)
            default:
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_loadData_호출하면_productList_GET하는지_확인() {
        // given
        var products: [Product] = []
        
        MockURLProtocol.requestHandler = {request in
            let exampleData = self.dummyProductListData
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type" : "application/json"])!
            return (response, exampleData)
        }
        
        let expectation = XCTestExpectation(description: "It gives productList")
        
        // when
        httpManager.loadData(targetURL: HTTPManager.TargetURL.productList(pageNumber: 2, itemsPerPage: 10)) { data in
            switch data {
            case .success(let data):
                let decodedData = try! JSONDecoder().decode(OpenMarketProductList.self, from: data)
                products = decodedData.products
            default:
                break
            }
            
            // then
            XCTAssertEqual(products.first?.name, "Test Product")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_loadData_호출하면_productDetail_GET하는지_확인() {
        // given
        var product: Product?
        
        MockURLProtocol.requestHandler = {request in
            let exampleData = self.dummyProductDetailData
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type" : "application/json"])!
            return (response, exampleData)
        }
        
        let expectation = XCTestExpectation(description: "It gives productDetail")
        
        // when
        httpManager.loadData(targetURL: HTTPManager.TargetURL.productDetail(productNumber: 522)) { data in
            switch data {
            case .success(let data):
                let decodedData = try! JSONDecoder().decode(Product.self, from: data)
                product = decodedData
            default:
                break
            }
            
            // then
            guard let product = product else {
                return
            }
            XCTAssertEqual(product.name, "아이폰13")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
