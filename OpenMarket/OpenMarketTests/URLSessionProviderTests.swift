//
//  URLSessionProviderTests.swift
//  OpenMarketTests
//
//  Created by JeongTaek Han on 2022/01/06.
//

import XCTest

class URLSessionProviderTests: XCTestCase {
    
    var sutURLSesssionProvider: URLSessionProvider!
    var sutTestExpectation: XCTestExpectation!

    override func setUpWithError() throws {
        self.sutURLSesssionProvider = URLSessionProvider(session: URLSession.shared)
        self.sutTestExpectation = XCTestExpectation()
    }

    override func tearDownWithError() throws {
        self.sutURLSesssionProvider = nil
        self.sutTestExpectation = nil
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
                self.sutTestExpectation.fulfill()
            case .failure(let error):
                XCTFail("\(error)")
                self.sutTestExpectation.fulfill()
            }
        }
        wait(for: [sutTestExpectation], timeout: 10.0)
    }
    
    func test_showPage가_200번때_상태코드를_반환해야한다() {
        sutURLSesssionProvider.request(.showProductPage(pageNumber: "1", itemsPerPage: "10")) { result in
            switch result {
            case .success(let data):
                guard let stringData = String(data: data, encoding: .utf8) else {
                    XCTFail()
                    return
                }
                print(stringData)
                XCTAssertTrue(true)
                self.sutTestExpectation.fulfill()
            case .failure(let error):
                XCTFail("\(error)")
                self.sutTestExpectation.fulfill()
            }
        }
        wait(for: [sutTestExpectation], timeout: 10.0)
    }
    
    func test_showProductDetail가_200번때_상태코드를_반환해야한다() {
        sutURLSesssionProvider.request(.showProductDetail(productID: "92")) { result in
            switch result {
            case .success(let data):
                guard let stringData = String(data: data, encoding: .utf8) else {
                    XCTFail()
                    return
                }
                print(stringData)
                XCTAssertTrue(true)
                self.sutTestExpectation.fulfill()
            case .failure(let error):
                XCTFail("\(error)")
                self.sutTestExpectation.fulfill()
            }
        }
        wait(for: [sutTestExpectation], timeout: 10.0)
    }
    
    func test_showProductSecret가_200번때_상태코드를_반환해야한다() {
        let sellerID = "cd706a3e-66db-11ec-9626-796401f2341a"
        let sellerPassword = "password"
        sutURLSesssionProvider.request(.showProductSecret(sellerID: sellerID, sellerPW: sellerPassword, productID: "92")) { result in
            switch result {
            case .success(let data):
                guard let stringData = String(data: data, encoding: .utf8) else {
                    XCTFail()
                    return
                }
                print(stringData)
                XCTAssertTrue(true)
                self.sutTestExpectation.fulfill()
            case .failure(let error):
                XCTFail("\(error)")
                self.sutTestExpectation.fulfill()
            }
        }
        wait(for: [sutTestExpectation], timeout: 10.0)
    }

    func test_deleteProduct가_200번때_상태코드를_반환해야한다() {
        let sellerID = "cd706a3e-66db-11ec-9626-796401f2341a"
        let productPassword = "e68a07c6-6fd7-11ec-abfa-8fdc4e022780"
        sutURLSesssionProvider.request(.deleteProduct(sellerID: sellerID, productID: "94", productSecret: productPassword)) { result in
            switch result {
            case .success(let data):
                guard let stringData = String(data: data, encoding: .utf8) else {
                    XCTFail()
                    return
                }
                print(stringData)
                XCTAssertTrue(true)
                self.sutTestExpectation.fulfill()
            case .failure(let error):
                XCTFail("\(error)")
                self.sutTestExpectation.fulfill()
            }
        }
        wait(for: [sutTestExpectation], timeout: 10.0)
    }
    
    func test_createProduct가_200번때_상태코드를_반환해야한다() {
        let sellerID = "cd706a3e-66db-11ec-9626-796401f2341a"
        let param = CreateProductRequestParams(name: "신나무", descriptions: "야곰아카데미캠퍼", price: 9999999999, currency: .USD, discountedPrice: nil, stock: 1, secret: "password")
        guard let paramData = try? JSONEncoder().encode(param) else {
            XCTFail()
            return
        }
        guard let data = UIImage(named: "Image")?.pngData() else {
            XCTFail()
            return
        }
        
        let image = Image(type: .png, data: data)
        
        sutURLSesssionProvider.request(.createProduct(sellerID: sellerID, params: paramData, images: [image])) { result in
            switch result {
            case .success(let data):
                guard let stringData = String(data: data, encoding: .utf8) else {
                    XCTFail()
                    return
                }
                print(stringData)
                XCTAssertTrue(true)
                self.sutTestExpectation.fulfill()
            case .failure(let error):
                XCTFail("\(error)")
                self.sutTestExpectation.fulfill()
            }
        }
        wait(for: [sutTestExpectation], timeout: 10.0)
    }
    
    func test_updateProduct가_200번때_상태코드를_반환해야한다() {
        let sellerID = "cd706a3e-66db-11ec-9626-796401f2341a"
        let secret = "password"
        let param = UpdateProductRequestModel(name: nil, descriptions: nil, thumbnailID: nil, price: 10, currency: nil, discountedPrice: nil, secret: secret)
        
        sutURLSesssionProvider.request(.updateProduct(sellerID: sellerID, productID: "92", body: param)) { result in
            switch result {
            case .success(let data):
                guard let stringData = String(data: data, encoding: .utf8) else {
                    XCTFail()
                    return
                }
                print(stringData)
                XCTAssertTrue(true)
                self.sutTestExpectation.fulfill()
            case .failure(let error):
                XCTFail("\(error)")
                self.sutTestExpectation.fulfill()
            }
        }
        wait(for: [sutTestExpectation], timeout: 10.0)
    }
    
}
