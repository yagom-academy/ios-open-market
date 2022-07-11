//
//  ProductAPITests.swift
//  ProductAPITests
//
//  Created by Gordon Choi on 2022/07/11.
//

import XCTest
@testable import OpenMarket

class ProductAPITests: XCTestCase {
    var sut: ProductAPI!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ProductAPI()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func test_주어진_파일에서_데이터반환() {
        // given
        let expectation = "KRW"

        // when
        let fetchedData = sut.fetch("products", for: Products.self)
        var result: Products? {
            switch fetchedData {
            case .success(let products):
                return products
            case .failure(_):
                return nil
            }
        }
        let currency = result?.pages[0].currency

        // then
        XCTAssertEqual(expectation, currency)
    }

    func test_데이터파일이_없을때_jsonFileNotFound_오류반환() {
        // given
        let expectation = APIError.jsonFileNotFound

        // when
        let fetchedData = sut.fetch("product", for: Products.self)
        var error: APIError? {
            switch fetchedData {
            case .success(_):
                return nil
            case .failure(let error):
                return error
            }
        }

        // then
        XCTAssertEqual(expectation, error)
    }

    func test_디코딩에_실패했을때_failedToDecode_오류반환() {
        // given
        let expectation = APIError.failedToDecode

        // when
        let fetchedData = sut.fetch("products", for: Product.self)
        var error: APIError? {
            switch fetchedData {
            case .success(_):
                return nil
            case .failure(let error):
                return error
            }
        }

        // then
        XCTAssertEqual(expectation, error)
    }
}
