//
//  RequestTests.swift
//  OpenMarketTests
//
//  Created by groot, bard on 2022/07/12.
//

import XCTest
@testable import OpenMarket

final class RequestTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func test_mockSession을받아와서_디코딩이잘되는지() {
        // given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        var resultName: String?
        let request = ProductGetRequest()
        
        let mockSession = MockSession()
        mockSession.dataTask(with: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                guard let decoededData = success.decodeData(type: ProductsList.self) else { return }
                resultName = decoededData.pages[0].name
            case .failure(_):
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 300)
        
        // when
        let result = "Test Product"
        
        // then
        XCTAssertEqual(result, resultName)
    }
    
    func test_APIRequest를_받아와서_디코딩이_잘되는지() {
        // given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        var resultName: String?
        let request = ProductGetRequest()
        
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                guard let decoededData = success.decodeData(type: ProductsList.self) else { return }
                resultName = decoededData.pages[0].name
            case .failure(_):
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 300)
        
        // when
        let result = "내가 울어요"
        
        // then
        XCTAssertEqual(result, resultName)
    }
    
    func test_상품상세조회가_잘되는지() {
        // given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        var resultName: String?
        var request = ProductGetRequest()
        request.productID = "4537"
        
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                guard let decoededData = success.decodeData(type: ProductDetail.self) else { return }
                resultName = decoededData.name
            case .failure(_):
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 300)
        
        // when
        let result = "치킨 먹었다"
        
        // then
        XCTAssertEqual(result, resultName)
    }
    
    func test_상품등록이_잘되는지() {
        // given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        guard let assetImage = UIImage(named: "1") else { return }
        guard let pngData = assetImage.pngData() else { return }
        
        let product = RegistrationProduct(name: "힘내라 수꿍!",
                                          descriptions: "ㅎ",
                                          price: 1.0,
                                          currency: "KRW",
                                          discountedPrice: 0.0,
                                          stock: 1,
                                          secret: "R49CfVhSdh")
        guard let productData = try? JSONEncoder().encode(product) else { return }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let images = [Image(name: "asdf", data: pngData, type: "png")]
        let multipartForm = MultiPartForm(jsonParameterName: "params",
                                          imageParameterName: "images",
                                          boundary: boundary,
                                          jsonData: productData,
                                          images: images)
        
        var postRequest = ProductPostRequest()
        postRequest.body = .multiPartForm(multipartForm)
        postRequest.additionHeaders = [HTTPHeaders.multipartFormData(boundary: boundary).key: HTTPHeaders.multipartFormData(boundary: boundary).value]
        
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: postRequest) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                print(String(decoding: success, as: UTF8.self))
            case .failure(let error):
                print(error)
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 300)
    }
    
    func test_상품시크릿넘버가_잘조회되는지() {
        // given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        let body = SecretProducts(secret: "R49CfVhSdh")
        guard let data = try? JSONEncoder().encode(body) else { return }
        
        var postRequest = ProductPostRequest()
        postRequest.additionHeaders = [HTTPHeaders.json.key: HTTPHeaders.json.value]
        postRequest.productID = "4539"
        postRequest.body = .json(data)
        
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: postRequest) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                print(String(decoding: success, as: UTF8.self))
            case .failure(let error):
                print(error)
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 300)
    }
    
    func test_상품삭제가_잘되는지() {
        // given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        let deleteRequest = ProductDeleteRequest(productID: "4539",
                                                 productSeceret: "ad6ade9d-1add-11ed-9676-11aee8bfbb3f")
        
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: deleteRequest) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                print(String(decoding: success, as: UTF8.self))
            case .failure(let error):
                print(error)
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 300)
    }
    
    func test_상품수정이_잘되는지() {
        // given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        let body = RegistrationProduct(name: "치킨 먹고싶다",
                                       descriptions: "나는 수정했다",
                                       price: 100000.0,
                                       currency: "KRW",
                                       discountedPrice: 0.0,
                                       stock: 0,
                                       secret: "R49CfVhSdh")
        guard let data = try? JSONEncoder().encode(body) else { return }
        
        var patchRequest = ProductPatchRequest(productID: "4537")
        patchRequest.body = .json(data)
        
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: patchRequest) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                print(String(decoding: success, as: UTF8.self))
            case .failure(let error):
                print(error)
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 300)
    }
}
