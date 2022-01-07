//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by yeha on 2022/01/06.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    var sut: ProductService!

    override func setUpWithError() throws {
        sut = ProductService()
    }

    func test_checkNetworkConnection() {
        let expectaion = XCTestExpectation(description: "")

        sut.checkNetworkConnection(session: HTTPUtility.defaultSession) { result in
            switch result {
            case .success(let data):
                guard let encodedData = String(data: data, encoding: .utf8) else {
                    return XCTFail("파싱 실패")
                }
                XCTAssertEqual(encodedData, "\"OK\"")
            case .failure:
                XCTFail("통신 실패")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }

    func test_retrieveProduct() {
        let expectaion = XCTestExpectation(description: "")

        sut.retrieveProduct(productIdentification: 87, session: HTTPUtility.defaultSession) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData: Product = try DecodeUtility.decode(data: data)
                    XCTAssertEqual(decodedData.name, "aladdin")
                } catch {
                    XCTFail("파싱 실패")
                }
            case .failure:
                XCTFail("통신 실패")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }
}
