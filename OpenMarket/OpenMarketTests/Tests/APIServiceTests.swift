//
//  APIServiceTests.swift
//  OpenMarketTests
//
//  Created by 권나영 on 2022/01/07.
//

import XCTest
@testable import OpenMarket

final class APIServiceTests: XCTestCase {
    func testGetPage_givenSuccessfulRequest_expectCorrectData() {
        let stubURLSession = StubURLSession(isSuccessfulRequest: true, mockRequest: .getPage)
        let sut = MarketAPIService(session: stubURLSession)
        let expectedData = try? JSONDecoder().decode(Page.self, from: stubURLSession.request.data)
        
        sut.fetchPage(pageNumber: 1, itemsPerPage: 1) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, expectedData)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testGetPage_givenFailureRequest_expectInvalidRequestError() {
        let stubURLSession = StubURLSession(isSuccessfulRequest: false, mockRequest: .getPage)
        let sut = MarketAPIService(session: stubURLSession)
        
        sut.fetchPage(pageNumber: 1, itemsPerPage: 1) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .unsuccessfulStatusCode(statusCode: 410))
            }
        }
    }
    
    func testGetProduct_givenSuccessfulRequest_expectCorrectData() {
        let stubURLSession = StubURLSession(isSuccessfulRequest: true, mockRequest: .getProduct)
        let sut = MarketAPIService(session: stubURLSession)
        let expectedData = try? JSONDecoder().decode(Product.self, from: stubURLSession.request.data)
        
        sut.fetchProduct(productID: 87) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, expectedData)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testGetProduct_givenFailureRequest_expectInvalidRequestError() {
        let stubURLSession = StubURLSession(isSuccessfulRequest: false, mockRequest: .getProduct)
        let sut = MarketAPIService(session: stubURLSession)
        
        sut.fetchProduct(productID: 87) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .unsuccessfulStatusCode(statusCode: 410))
            }
        }
    }
    
    func testRegisterProduct_givenSuccessfulRequest_expectCorrectData() {
        let stubURLSession = StubURLSession(isSuccessfulRequest: true, mockRequest: .getPage)
        let sut = MarketAPIService(session: stubURLSession)
        let expectedData = try? JSONDecoder().decode(Product.self, from: stubURLSession.request.data)
        guard let image = UIImage(named: "olaf") else {
            return
        }
        let dummyProduct = PostProduct(
            name: "zoe",
            descriptions: "desc",
            price: 0,
            currency: "KRW",
            discountedPrice: 0,
            stock: 0,
            secret: "password"
        )
        let dummyImage = ProductImage(
            name: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/origin/5b5a5f22790111ec9173b76aa80a2e69.jpeg",
            type: .jpeg,
            image: image
        )
        
        sut.registerProduct(product: dummyProduct, images: [dummyImage]) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, expectedData)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testRegisterProduct_givenFailureRequest_expectInvalidRequestError() {
        let stubURLSession = StubURLSession(isSuccessfulRequest: false, mockRequest: .registerProduct)
        let sut = MarketAPIService(session: stubURLSession)
        guard let image = UIImage(named: "olaf") else {
            return
        }
        let dummyProduct = PostProduct(
            name: "zoe",
            descriptions: "desc",
            price: 0,
            currency: "KRW",
            discountedPrice: 0,
            stock: 0,
            secret: "password"
        )
        let dummyImage = ProductImage(
            name: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/origin/5b5a5f22790111ec9173b76aa80a2e69.jpeg",
            type: .jpeg,
            image: image
        )
        
        sut.registerProduct(product: dummyProduct, images: [dummyImage]) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .unsuccessfulStatusCode(statusCode: 410))
            }
        }
    }
    
    func testUpdateProduct_givenSuccessfulRequest_expectCorrectData() {
        let stubURLSession = StubURLSession(isSuccessfulRequest: true, mockRequest: .updateProduct)
        let sut = MarketAPIService(session: stubURLSession)
        let expectedData = try? JSONDecoder().decode(Product.self, from: stubURLSession.request.data)
        let dummyProduct = PatchProduct(
            name: "aladdin",
            descriptions: nil,
            thumbnailID: nil,
            price: nil,
            currency: nil,
            discountedPrice: nil,
            stock: nil,
            secret: "password"
        )
        
        sut.updateProduct(productID: 533, product: dummyProduct) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, expectedData)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testUpdateProduct_givenFailureRequest_expectInvalidRequestError() {
        let stubURLSession = StubURLSession(isSuccessfulRequest: false, mockRequest: .updateProduct)
        let sut = MarketAPIService(session: stubURLSession)
        let dummyProduct = PatchProduct(
            name: "aladdin",
            descriptions: nil,
            thumbnailID: nil,
            price: nil,
            currency: nil,
            discountedPrice: nil,
            stock: nil,
            secret: "password"
        )
        
        sut.updateProduct(productID: 533, product: dummyProduct) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .unsuccessfulStatusCode(statusCode: 410))
            }
        }
    }
}
