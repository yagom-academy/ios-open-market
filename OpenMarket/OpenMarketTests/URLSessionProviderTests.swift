//
//  URLSessionProviderTests.swift
//  OpenMarketTests
//
//  Created by JeongTaek Han on 2022/01/06.
//

import XCTest

class URLSessionProviderTests: XCTestCase {
    
    var sutURLSesssionProvider: URLSessionProvider!

    override func setUpWithError() throws {
        self.sutURLSesssionProvider = URLSessionProvider(session: URLSession.shared, baseURL: "")
    }

    override func tearDownWithError() throws {
        self.sutURLSesssionProvider = nil
    }

    func test_healthCheck가_200번때_상태코드를_반환해야한다() {
        sutURLSesssionProvider.request(.checkHealth) { result in
            switch result {
            case .success(let data):
                guard let stringData = String(data: data, encoding: .utf8) else {
                    XCTFail()
                    return
                }
                print(stringData)
                XCTAssertTrue(true)
            case .failure(let error):
                XCTFail("\(error)")
            }
        }
    }
    
    func test_showPage가_200번때_상태코드를_반환해야한다() {
        sutURLSesssionProvider.request(.showPage(pageNumber: 1, itemsPerPage: 10)) { result in
            switch result {
            case .success(let data):
                guard let stringData = String(data: data, encoding: .utf8) else {
                    XCTFail()
                    return
                }
                print(stringData)
                XCTAssertTrue(true)
            case .failure(let error):
                XCTFail("\(error)")
            }
        }
    }
    
    func test_showProductDetail가_200번때_상태코드를_반환해야한다() {
        sutURLSesssionProvider.request(.showProductDetail(productID: 39)) { result in
            switch result {
            case .success(let data):
                guard let stringData = String(data: data, encoding: .utf8) else {
                    XCTFail()
                    return
                }
                print(stringData)
                XCTAssertTrue(true)
            case .failure(let error):
                XCTFail("\(error)")
            }
        }
    }

}
