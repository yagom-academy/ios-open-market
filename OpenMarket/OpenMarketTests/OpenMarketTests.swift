//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Zero DotOne on 2021/01/27.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    let networkLayer = NetworkLayer()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRequestItemList() throws {
        let expectation = XCTestExpectation(description: "목록 조회")
        networkLayer.requestItemList(page: 1) { data, _, _ in
            XCTAssertNotNil(data, "목록 조회 실패")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testRequestItemRegistration() throws {
        let expectation = XCTestExpectation(description: "상품 등록")
        let imageData = UIImage(systemName: "pencil")!.pngData()!
        let item = ItemRegistrationRequest(
            title: "상품 등록",
            descriptions: "상품 등록 테스트",
            price: 100,
            currency: "KRW",
            stock: 100,
            discountedPrice: 50,
            images: [imageData],
            password: "test")

        networkLayer.requestRegistration(bodyData: item) { data, _, _ in
            XCTAssertNotNil(data, "상품 등록 실패")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testRequestItemSpecification() throws {
        let expectation = XCTestExpectation(description: "상품 조회")
        let number = 400
        networkLayer.requestSpecification(number: number) { data, _, _ in
            XCTAssertNotNil(data, "상품 조회 실패")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestItemModification() throws {
        let expectation = XCTestExpectation(description: "상품 수정")
        let imageData = UIImage(systemName: "pencil")!.pngData()!
        let item = ItemModificationRequest(
            title: "상품 수정",
            descriptions: "상품 수정 테스트",
            price: 100,
            currency: "KRW",
            stock: 100,
            discountedPrice: 50,
            images: [imageData],
            password: "1234")

        networkLayer.requestModification(number: 400, bodyData: item) { data, _, _ in
            XCTAssertNotNil(data, "상품 수정")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestItemDeletion() throws {
        let expectation = XCTestExpectation(description: "상품 삭제")
        let item = ItemDeletionRequest(id: 400, password: "test")

        networkLayer.requestDeletion(number: 400, bodyData: item) { data, _, _ in
            XCTAssertNotNil(data, "상품 삭제")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
