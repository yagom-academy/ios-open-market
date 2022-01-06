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
        self.sutURLSesssionProvider = URLSessionProvider(session: URLSession.shared)
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
        sutURLSesssionProvider.request(.showProductPage(pageNumber: 1, itemsPerPage: 10)) { result in
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

    func test_deleteProduct가_200번때_상태코드를_반환해야한다() {
        let sellerID = "cd706a3e-66db-11ec-9626-796401f2341a"
        let productPassword = "7e90b940-6ec1-11ec-abfa-c95e9e5e9ca8"
        sutURLSesssionProvider.request(.deleteProduct(sellerID: sellerID, productID: 48, productSecret: productPassword)) { result in
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
    
    func test_createProduct가_200번때_상태코드를_반환해야한다() {
        let sellerID = "cd706a3e-66db-11ec-9626-796401f2341a"
        let param = CreateProductRequestParams(name: "신나무", descriptions: "야곰아카데미캠퍼", price: 9999999999, currency: .USD, discountedPrice: nil, stock: 1, secret: "password")
        guard let paramData = try? JSONEncoder().encode(param) else {
            XCTFail()
            return
        }
        guard let imageData = UIImage(named: "Image")?.pngData() else {
            XCTFail()
            return
        }
        sutURLSesssionProvider.request(.createProduct(sellerID: sellerID, params: paramData, images: [imageData])) { result in
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
    
    func test_updateProduct가_200번때_상태코드를_반환해야한다() {
        let sellerID = "cd706a3e-66db-11ec-9626-796401f2341a"
        let secret = "password"
        let param = UpdateProductRequest(name: nil, descriptions: nil, thumbnailID: nil, price: 10, currency: nil, discountedPrice: nil, secret: secret)
        guard let paramData = try? JSONEncoder().encode(param) else {
            XCTFail()
            return
        }
        sutURLSesssionProvider.request(.updateProduct(sellerID: sellerID, productID: 40, body: paramData)) { result in
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
