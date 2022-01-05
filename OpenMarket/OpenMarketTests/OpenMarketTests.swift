//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Jun Bang on 2022/01/05.
//

import XCTest

class OpenMarketTests: XCTestCase {
    var sut: MarketAPIService!
    
    override func setUpWithError() throws {
        sut = MarketAPIService()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testParsePage_productsJSONFile_expectCorrectPageProperties() {
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
    
    func testProductModel_firstProductOfArray_expectCorrectProduct() {
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
    
    private func parsePage() -> Page? {
        guard let data = NSDataAsset(name: "products")?.data else {
            return nil
        }
        guard let page: Page = sut.parse(with: data) else {
            return nil
        }
        
        return page
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
