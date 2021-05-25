//
//  MockTest.swift
//  OpenMarketTests
//
//  Created by steven on 2021/05/21.
//

import XCTest
@testable import OpenMarket

class MockTest: XCTestCase {

//    func test_mock() {
//        let networkHelper = NetworkHelper.init()
//
//        let promise = expectation(description: "mock test done")
//
//        networkHelper.readItem(itemNum: 1) { result in
//            switch result {
//            case .success(let item):
//                XCTAssertEqual(item.id, 1)
//            case .failure:
//                XCTFail()
//            }
//            promise.fulfill()
//        }
//        wait(for: [promise], timeout: 5)
//    }
    
    func test_상품_조회() {
        // given
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: configuration)
        let networkHelper = NetworkHelper(session: mockSession)
        
        guard let data = NSDataAsset(name: "item")?.data else {
            XCTFail()
            return
        }
        
        guard let mockJsonItem = try? JSONDecoder().decode(Product.self, from: data) else {
            XCTFail()
            return
        }
        
        MockURLProtocol.requsetHandler = { request in
            let response = HTTPURLResponse(url: URL(string: RequestAddress.readItem(id: 1).url)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (data, response, nil)
        }
        
        let promise = expectation(description: "Mock test")
        
        // when
        networkHelper.readItem(itemNum: 1) { result in
            
            // then
            switch result {
            case .success(let item):
                XCTAssertEqual(item.id, mockJsonItem.id)
            case .failure:
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 2)
    }
    
    func test_실제_상품_등록() {
        let mockItemForm = ProductForm(title: "수지", descriptions: "수지좋아", price: 1000, currency: "USD", stock: 90, discountedPrice: 999, images: [(UIImage(named: "vanilla")?.pngData())!], password: "1234")
        
        let networkHelper = NetworkHelper()
        
        let promise = expectation(description: "test")
        
        networkHelper.createItem(itemForm: mockItemForm) { result in
            switch result {
            case .success(let item):
                XCTAssertNil(item.title)
            case .failure(let error):
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_상품_등록() {
        
        let mockItemForm = ProductForm(title: "수지", descriptions: "수지좋아", price: 1000, currency: "USD", stock: 90, discountedPrice: 999, images: [(UIImage(named: "vanilla")?.pngData())!], password: "1234")
        
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: configuration)
        let networkHelper = NetworkHelper(session: mockSession)
        
        guard let data = NSDataAsset(name: "item")?.data else {
            XCTFail()
            return
        }
        
//        var postRequest: URLRequest?
        
        let promise = expectation(description: "Mock test")
        
        MockURLProtocol.requsetHandler = { request in
            // 제 생각에는 여기에 request에서 request.httpbody를 접근하면 될 것 같은데..
            // 계속 nil이 찍혀요
            // request.allHTTPHeaderFields 에는 멀티파트 폼 해더가 잘 저장되어 있습니다.
            print(request.allHTTPHeaderFields)
            print(request.httpMethod)
            print(request.httpBody)
//            postRequest = request
            
            let response = HTTPURLResponse(url: URL(string: RequestAddress.createItem.url)!, statusCode: 200, httpVersion: nil, headerFields: nil)
                        
            return (data, response, nil)
        }
        
        networkHelper.createItem(itemForm: mockItemForm) { result in
//            print(postRequest?.httpBody)
            switch result {
            case .success(let item):
                XCTAssert(true)
            case .failure(let error):
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 2.0)
    }
}
