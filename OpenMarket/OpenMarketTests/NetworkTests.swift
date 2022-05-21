//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by dudu, safari on 2022/05/09.
//

import XCTest

@testable import OpenMarket

class NetworkTests: XCTestCase {
    
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}
    
    func test_네트워크에_서버상태요청시_OK가_넘어오는지() {
        // given
        let promise = expectation(description: "will return OK message")
        let sut = NetworkManager<String>()
        
        // when
        sut.checkServerState { result in
            // then
            switch result {
            case .success(let text):
                XCTAssertEqual("OK", text)
            case .failure(_):
                XCTAssert(false, "에러 발생하면 안됨")
            }
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10)
    }
    
    func test_네트워크통신없이_요청시_성공하는_경우() {
        // given
        let endPoint = EndPoint.requestList(page: 1, itemsPerPage: 10, httpMethod: .get)
        
        MockURLProtocol.requsetHandler = { requset in
            let urlReponse = HTTPURLResponse(url: endPoint.urlRequst!.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            let dummyData = DummyData().data!
            
            return (urlReponse, dummyData)
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        
        let mockSession = URLSession(configuration: configuration)
        let sut = NetworkManager<ProductList>(session: mockSession)
        let promise = expectation(description: "will return productList")
        
        // when
        sut.request(endPoint: endPoint) { result in
            // then
            switch result {
            case .success(let list):
                XCTAssertEqual(list.pageNo, 1)
                XCTAssertEqual(list.itemsPerPage, 20)
                XCTAssertEqual(list.totalCount, 10)
            case .failure(_):
                XCTAssert(false, "에러 발생하면 안됨")
            }
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10)
    }
    
    func test_네트워크통신없이_요청시_실패하는_경우() {
        // given
        let endPoint = EndPoint.requestList(page: 1, itemsPerPage: 10, httpMethod: .get)
        
        MockURLProtocol.requsetHandler = { requset in
            let urlReponse = HTTPURLResponse(url: endPoint.urlRequst!.url!, statusCode: 404, httpVersion: "2.0", headerFields: nil)!
            let dummyData = DummyData().data!
            
            return (urlReponse, dummyData)
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        
        let mockSession = URLSession(configuration: configuration)
        let sut = NetworkManager<ProductList>(session: mockSession)
        let promise = expectation(description: "will return productList")

        // when
        sut.request(endPoint: endPoint) { result in
            // then
            switch result {
            case .success(_):
                XCTAssert(false, "성공하면 안됨")
            case .failure(_):
                XCTAssert(true, "테스트 성공")
            }
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10)
    }
}
