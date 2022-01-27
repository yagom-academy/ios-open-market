//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 서녕 on 2022/01/07.
//
import XCTest

class OpenMarketTests: XCTestCase {
    let mockSession = MockURLSession()
    var sut: URLSessionProvider!

    override func setUpWithError() throws {
        sut = .init(session: mockSession)
    }

    func test_getPage_success() {
        let responce = try? parsePageJSON()

        sut.getPage(id: 1) { result in
            switch result {
            case .success(let data):
                guard let page = try? JSONDecoder().decode(Page.self, from: data) else {
                    XCTFail("Decode Error")
                    return
                }

                XCTAssertEqual(page.productsInPage.first?.price, responce?.productsInPage.first?.price)
                XCTAssertEqual(page.productsInPage.first?.bargainPrice, responce?.productsInPage.first?.bargainPrice)

            case .failure(_):
                XCTFail("getPage failure")
            }
        }
    }

    func test_getPage_failure() {
        sut = URLSessionProvider(session: MockURLSession(isRequestSuccess: false))

        sut.getPage(id: 1) { result in
            switch result {
            case .success(_):
                    XCTFail("result is success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.statusCodeError)
            }
        }
    }
}
