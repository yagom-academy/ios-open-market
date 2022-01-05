//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Jun Bang on 2022/01/05.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    var sut: MarketAPIService!
    
    override func setUpWithError() throws {
        sut = MarketAPIService()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testParser_givenProductsFile_expectThrowError() {
        guard let data = NSDataAsset(name: "products")?.data else {
            return
        }
        
        XCTAssertNoThrow(try sut.parse(with: data, type: Page.self))
    }
    
    func testPageModel_givenParsedJSONData_expectCorrectPageProperties() {
        guard let page = parsePage() else {
            return
        }
        
        let pageNumber = page.pageNumber
        let itemsPerPage = page.itemsPerPage
        let totalCount = page.totalCount
        let offset = page.offset
        let limit = page.limit
        
        XCTAssertEqual(pageNumber, 1)
        XCTAssertEqual(itemsPerPage, 20)
        XCTAssertEqual(totalCount, 10)
        XCTAssertEqual(offset, 0)
        XCTAssertEqual(limit, 20)
    }
    
    func testProductModel_givenFirstProductOfArray_expectCorrectProduct() {
        guard let page = parsePage() else {
            return
        }
        guard let product = page.products.first else {
            return
        }
        
        let testProduct = Product(id: 20,
                                  vendorID: 3,
                                  name: "Test Product",
                                  thumbnailURL: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/5a0cd56b6d3411ecabfa97fd953cf965.jpg",
                                  currency: "KRW",
                                  price: 0,
                                  bargainPrice: 0,
                                  discountedPrice: 0,
                                  stock: 0,
                                  createdAt: "2022-01-04T00:00:00.00",
                                  issuedAt: "2022-01-04T00:00:00.00")
        
        XCTAssertEqual(product, testProduct)
    }
    
    func testProductModel_givenLastProductOfArray_expectCorrectProduct() {
        guard let page = parsePage() else {
            return
        }
        guard let product = page.products.last else {
            return
        }
        
        let testProduct = Product(id: 2,
                                  vendorID: 2,
                                  name: "팥빙수",
                                  thumbnailURL: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/2/thumb/a3257844661911ec8eff5b6e36134cb4.png",
                                  currency: "KRW",
                                  price: 2000,
                                  bargainPrice: 2000,
                                  discountedPrice: 0,
                                  stock: 0,
                                  createdAt: "2021-12-26T00:00:00.00",
                                  issuedAt: "2021-12-26T00:00:00.00")
        
        XCTAssertEqual(product, testProduct)
    }
    
    private func parsePage() -> Page? {
        guard let data = NSDataAsset(name: "products")?.data else {
            return nil
        }
        do {
            let page = try sut.parse(with: data, type: Page.self)
            return page
        } catch JSONError.parsingError {
            print(JSONError.parsingError.description)
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id &&
            lhs.vendorID == rhs.vendorID &&
            lhs.name == rhs.name &&
            lhs.currency == rhs.currency &&
            lhs.price == rhs.price &&
            lhs.bargainPrice == rhs.bargainPrice &&
            lhs.discountedPrice == rhs.discountedPrice &&
            lhs.stock == rhs.stock &&
            lhs.createdAt == rhs.createdAt &&
            lhs.issuedAt == rhs.issuedAt
    }
}
