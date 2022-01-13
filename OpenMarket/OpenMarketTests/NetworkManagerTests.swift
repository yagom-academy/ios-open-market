//
//  NetworkManagerTests.swift
//  OpenMarketTests
//
//  Created by 이호영 on 2022/01/05.
//

import XCTest
@testable import OpenMarket

class NetworkManagerTests: XCTestCase {
    var stubProducts = NSDataAsset(name: "products")!.data
    var stubProduct = NSDataAsset(name: "product")!.data
    var sutNetworkManager: NetworkManager?
    var sutURL: URL?
    var sutData: Data?
    var sutRequest: URLRequest?
    
    override func setUpWithError() throws {
        let session = MockSession.session
        let netWork = Network(session: session)
        let parser = StubParser()
        sutNetworkManager = NetworkManager(network: netWork, parser: parser)
        sutURL = URL(string: "testURL")
        sutData = self.stubProducts
        sutRequest = URLRequest(url: sutURL!)
    }
    
    override func tearDownWithError() throws {
        sutNetworkManager = nil
        sutURL = nil
        sutData = nil
        sutRequest = nil
    }
    
    func test_Fetch_Success() {
        // given
        let response = HTTPURLResponse(url: sutURL!, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockURLs = [sutURL!: (nil, sutData, response)]
        let decodingtype = Products.self
        let expectation = XCTestExpectation(description: "네트워크 실행")
        
        //when
        sutNetworkManager?.fetch(request: sutRequest!, decodingType: decodingtype) { result in
           
            // then
            switch result {
            case .success:
                XCTAssert(true)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_Fetch_Decode_failure() {
        // given
        let response = HTTPURLResponse(url: sutURL!, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockURLs = [sutURL!: (nil, sutData, response)]
        let decodingtype = StubProduct.self
        let expectation = XCTestExpectation(description: "네트워크 실행")
        
        //when
        sutNetworkManager?.fetch(request: sutRequest!, decodingType: decodingtype) { result in
            
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure:
                XCTAssert(true)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_Fetch_Network_failure() {
        // given
        let response = HTTPURLResponse(url: sutURL!, statusCode: 404, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockURLs = [sutURL: (nil, sutData, response)]
        let decodingtype = Products.self
        let expectation = XCTestExpectation(description: "네트워크 실행")
        
        //when
        sutNetworkManager?.fetch(request: sutRequest!, decodingType: decodingtype) { result in
        
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure:
                XCTAssert(true)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_request_상품리스트조회() {
        //given
        let url = APIAddress.products(page: 1, itemsPerPage: 10).url
        
        //when
        let result = sutNetworkManager?.requestListSearch(page: 1, itemsPerPage: 10)
        
        //then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.url, url)
        XCTAssertEqual(result?.httpMethod, HTTPMethod.get.rawValue)
    }
    
    func test_request_상품상세조회() {
        //given
        let url = APIAddress.product(id: 1).url
        
        //when
        let result = sutNetworkManager?.requestDetailSearch(id: 1)
        
        //then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.url, url)
        XCTAssertEqual(result?.httpMethod, HTTPMethod.get.rawValue)
    }
    
    func test_request_상품삭제Secret조회() {
        //given
        let url = APIAddress.secretSearch(id: 1).url
        //when
        let result = sutNetworkManager?.requestSecretSearch(data: Data(), id: 1, secret: "123")
        
        switch result {
        case .success(let request):
            //then
            XCTAssertNotNil(request)
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, HTTPMethod.post.rawValue)
        case .failure:
            XCTFail()
        case .none:
            XCTFail()
        }
    }
    
    func test_request_상품삭제() {
        //given
        let url = APIAddress.delete(id: 1, secret: "123").url
        
        //when
        let result = sutNetworkManager?.requestDelete(id: 1, secret: "123")
        
        //then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.url, url)
        XCTAssertEqual(result?.httpMethod, HTTPMethod.delete.rawValue)
    }
    
    func test_request_상품수정() {
        //given
        let url = APIAddress.product(id: 1).url
        
        //when
        let result = sutNetworkManager?.requestModify(data: Data(), id: 1)
        
        switch result {
        case .success(let request):
            //then
            XCTAssertNotNil(request)
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, HTTPMethod.patch.rawValue)
        case .failure:
            XCTFail()
        case .none:
            XCTFail()
        }
    }
    
    func test_request_상품등록() {
        //given
        let url = APIAddress.register.url
        let params = ProductRegistration(name: "", descriptions: "", price: 1, currency: .krw, discountedPrice: nil, stock: nil, secret: "")
        
        //when
        let result = sutNetworkManager?.requestRegister(params: params, images: [])
        
        switch result {
        case .success(let request):
            //then
            XCTAssertNotNil(request)
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, HTTPMethod.post.rawValue)
        case .failure:
            XCTFail()
        case .none:
            XCTFail()
        }
    }
}
