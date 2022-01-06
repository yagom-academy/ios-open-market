//
//  URLSessionProviderTests.swift
//  OpenMarketTests
//
//  Created by JeongTaek Han on 2022/01/06.
//

import XCTest

class URLSessionProviderTests: XCTestCase {
    
    var sutURLSesssionProvider: URLSessionProvider!
    var sutDispatchSemaphore: DispatchSemaphore!

    override func setUpWithError() throws {
        self.sutURLSesssionProvider = URLSessionProvider(session: URLSession.shared, baseURL: "")
        self.sutDispatchSemaphore = DispatchSemaphore(value: 0)
    }

    override func tearDownWithError() throws {
        self.sutURLSesssionProvider = nil
        self.sutDispatchSemaphore = nil
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
                self.sutDispatchSemaphore.signal()
            case .failure(let error):
                XCTFail("\(error)")
                self.sutDispatchSemaphore.signal()
            }
        }
        sutDispatchSemaphore.wait()
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
                self.sutDispatchSemaphore.signal()
            case .failure(let error):
                XCTFail("\(error)")
                self.sutDispatchSemaphore.signal()
            }
        }
        sutDispatchSemaphore.wait()
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
                self.sutDispatchSemaphore.signal()
            case .failure(let error):
                XCTFail("\(error)")
                self.sutDispatchSemaphore.signal()
            }
        }
        sutDispatchSemaphore.wait()
    }
    
    func test_showProductSecret가_200번때_상태코드를_반환해야한다() {
        let sellerID = "cd706a3e-66db-11ec-9626-796401f2341a"
        let sellerPassword = "password"
        sutURLSesssionProvider.request(.showProductSecret(sellerID: sellerID, sellerPW: sellerPassword, productID: 39)) { result in
            switch result {
            case .success(let data):
                guard let stringData = String(data: data, encoding: .utf8) else {
                    XCTFail()
                    return
                }
                print(stringData)
                XCTAssertTrue(true)
                self.sutDispatchSemaphore.signal()
            case .failure(let error):
                XCTFail("\(error)")
                self.sutDispatchSemaphore.signal()
            }
        }
        sutDispatchSemaphore.wait()
    }

}
