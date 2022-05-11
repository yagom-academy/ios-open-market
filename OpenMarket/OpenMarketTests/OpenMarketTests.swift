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
    
    func test_loadProductListData할때_올바른response받으면_completionHandler실행() {
        // given
        let promise = expectation(description: "It gives product name")
        let httpManager = HTTPManager()
        var products: [Product] = []
        // when
        let completionHandler: (Data) -> Void = { data in
            do {
                products = try JSONDecoder().decode(OpenMarketProductList.self, from: data).products
            } catch {
                return
            }
            // then
            XCTAssertEqual(products.first?.name, "피자와 맥주")
            promise.fulfill()
        }
        httpManager.loadData(targetURL: TargetURL.productList(pageNumber: 2, itemsPerPage: 10), completionHandler: completionHandler)
        wait(for: [promise], timeout: 10)
    }
    
    func test_loadProductDetailData할때_올바른response받으면_completionHandler실행() {
        // given
        let promise = expectation(description: "It gives product name")
        let httpManager = HTTPManager()
        var product: Product?
        // when
        let completionHandler: (Data) -> Void = { data in
            do {
                product = try JSONDecoder().decode(Product.self, from: data)
            } catch {
                return
            }
            // then
            guard let product = product else {
                return
            }
            XCTAssertEqual(product.name, "아이폰13")
            promise.fulfill()
        }
        httpManager.loadData(targetURL: TargetURL.productDetail(productNumber: 522), completionHandler: completionHandler)
        wait(for: [promise], timeout: 10)
    }
}
