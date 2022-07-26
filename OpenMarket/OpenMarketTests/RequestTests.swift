//
//  RequestTests.swift
//  OpenMarketTests
//
//  Created by groot, bard on 2022/07/12.
//

import XCTest
@testable import OpenMarket

struct GetData: APIRequest {
    var body: [String : Data]?
    var boundary: String?
    var path: String?
    var method: HTTPMethod = .get
    var baseURL: String {
        URLHost.openMarket.url + URLAdditionalPath.product.value
    }
    var headers: [String : String]?
    var query: [String : String]? = [Product.page.text: "1", Product.itemPerPage.text: "1"]
}

struct PostRequest: APIRequest {
    var body: [String : Data]?
    var boundary: String?
    var path: String?
    var method: HTTPMethod
    var baseURL: String
    var headers: [String : String]?
    var query: [String: String]?
}

final class RequestTests: XCTestCase {
    var sut: GetData?
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = GetData()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_mockSession을받아와서_디코딩이잘되는지() {
        // given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        var resultName: String?
        let mockSession = MockSession()
        
        mockSession.dataTask(with: sut!) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                guard let decoededData = success.decodeImageData() else { return }
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
        let myURLSession = MyURLSession()
        
        myURLSession.dataTask(with: sut!) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                guard let decoededData = success.decodeImageData() else { return }
                resultName = decoededData.pages[0].name
            case .failure(_):
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 300)
        
        // when
        let result = "사과"
        
        // then
        XCTAssertEqual(result, resultName)
    }
    
    func test_Post() {
        // given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        guard let assetImage = UIImage(named: "1") else { return }
        guard let pngData = assetImage.pngData() else { return }
        let product = RegistrationProduct(name: "바드는 천재",
                                          descriptions: "ㅎ",
                                          price: 10.0,
                                          currency: "KRW",
                                          discountedPrice: 0.0,
                                          stock: 0, secret: "R49CfVhSdh")
        guard let productData = try? JSONEncoder().encode(product) else { return }
        let boundary = "Boundary-\(UUID().uuidString)"
        let postData = PostRequest(body: ["params" : productData,
                                          "images": pngData],
                                   boundary: boundary,
                                   method: .post,
                                   baseURL: URLHost.openMarket.url + URLAdditionalPath.product.value,
                                   headers: ["identifier": "eef3d2e5-0335-11ed-9676-e35db3a6c61a",
                                             "Content-Type": "multipart/form-data; boundary=\(boundary)"])
        let myURLSession = MyURLSession()
        
        myURLSession.dataTask(with: postData) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error)
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 300)
    }
}
