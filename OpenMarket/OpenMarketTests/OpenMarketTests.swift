//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by papri, Tiana on 2022/05/10.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    func test_parse할때_파일이름이올바르면_OpenMarketService반환() {
        // given
        let fileName = "products"
        // when, then
        XCTAssertNoThrow(try OpenMarketProductList.parse(fileName: fileName))
    }
    
    func test_parse할때_파일이름이올바르면_Product배열반환() throws {
        // given
        let fileName = "products"
        // when
        let firstProduct = try OpenMarketProductList.parse(fileName: fileName).products.first
        // then
        XCTAssertEqual(firstProduct?.name, "Test Product")
    }
    
    func test_loadData할때_올바른response받으면_OpenMarketProductList디코드하고_completionHandler실행() {
        // given
        let promise = expectation(description: "It gives vendor name")
        let httpManager = HTTPManager()
        var products: [Product] = []
        // when
        let completionHandler: (Result<Data, NetworkError>) -> Void = { data in
            switch data {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(OpenMarketProductList.self, from: data) else {
                    return
                }
                products = decodedData.products
            case .failure(let error):
                print(error.rawValue)
            }
            // then
            XCTAssertEqual(products.first?.name, "피자와 맥주")
            promise.fulfill()
        }
        httpManager.loadData(targetURL: HTTPManager.TargetURL.productList(pageNumber: 2, itemsPerPage: 10), completionHandler: completionHandler)
        wait(for: [promise], timeout: 10)
    }
    
    func test_loadData할때_올바른response받으면_Product디코드하고_completionHandler실행() {
        // given
        let promise = expectation(description: "It gives product name")
        let httpManager = HTTPManager()
        var product: Product?
        // when
        let completionHandler: (Result<Data, NetworkError>) -> Void = { data in
            switch data {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(Product.self, from: data) else {
                    return
                }
                product = decodedData
            case .failure(let error):
                print(error.rawValue)
            }
            
            // then
            guard let product = product else {
                return
            }
            XCTAssertEqual(product.name, "아이폰13")
            promise.fulfill()
        }
        httpManager.loadData(targetURL: HTTPManager.TargetURL.productDetail(productNumber: 522), completionHandler: completionHandler)
        wait(for: [promise], timeout: 10)
    }
    
    func test_listenHealthChecker할때_올바른response받으면_StatusCode_200() {
        // given
        let promise = expectation(description: "It gives status code 200")
        let httpManager = HTTPManager()
        
        // when
        let completionHandler: (Result<HTTPURLResponse, NetworkError>) -> Void = { response in
            switch response {
            case .success(let response):
                XCTAssertEqual(response.statusCode, 200)
            case .failure(let error):
                print(error.rawValue)
            }
            promise.fulfill()
        }
        httpManager.listenHealthChecker(completionHandler: completionHandler)
        wait(for: [promise], timeout: 10)
    }
}
