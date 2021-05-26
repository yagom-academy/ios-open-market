//
//  SessionManagerTests.swift
//  OpenMarketTests
//
//  Created by 천수현 on 2021/05/13.
//

import XCTest
@testable import OpenMarket

class SessionManagerHTTPTests: XCTestCase {
    var sut: SessionManager!
    var dummyPatchingItem: PatchingItem!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        sut = SessionManager(requestBodyEncoder: MockRequestBodyEncoder(), session: urlSession)

        dummyPatchingItem = PatchingItem(title: nil, descriptions: nil, price: nil,
                                         currency: nil, stock: nil, discountedPrice: nil,
                                         images: nil, password: "1234")
    }
    
    override func tearDownWithError() throws {
        sut = nil
        dummyPatchingItem = nil
    }

    func test_request_실행중_client_error_발생시_sessionError를_completionHandler에_전달한다() {
        let expectation = XCTestExpectation()
        
        MockURLProtocol.requestHandler = { request in
            let error = OpenMarketError.didNotReceivedData as Error
            
            return (nil, nil, error)
        }
        
        sut.request(method: .get, path: .item(id: 1)) { result in
            switch result {
            case .success:
                XCTFail("success가 전달됨")
            case .failure(let error):
                XCTAssertEqual(error, .sessionError)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_원하는_response가_오지않은_경우_wrongResponse를_completionHandler에_전달한다() {
        let expectation = XCTestExpectation()

        MockURLProtocol.requestHandler = { request in
            let url = URL(string: "https://camp-open-market-2.herokuapp.com/")!
            let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
            let data = NSDataAsset(name: "Item")!.data
            
            return (response, data, nil)
        }
        
        sut.request(method: .get, path: .item(id: 1)) { result in
            switch result {
            case .success:
                XCTFail("success가 전달됨")
            case .failure(let error):
                XCTAssertEqual(error, .wrongResponse(404))
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_타입과_맞지않는_데이터를_request하려는_경우_requestDataTypeNotMatch를_completionHanlder에_전달한다() {
        let expectation = XCTestExpectation()
        let url: URL = URL(string: "https://yagom.net/")!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = NSDataAsset(name: "Item")!.data

            return (response, data, nil)
        }

        sut.request(method: .post, path: .item(id: nil), data: dummyPatchingItem) { result in
            switch result {
            case .success:
                XCTFail("성공하면 안됨")
            case .failure(let error):
                XCTAssertEqual(error, .requestDataTypeNotMatch)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }
    
    func test_GET으로_request를_할때_데이터를_전달하는_경우_requestGETWithData를_completionHanlder에_전달한다() {
        let expectation = XCTestExpectation()
        let url: URL = URL(string: "https://yagom.net/")!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = NSDataAsset(name: "Item")!.data

            return (response, data, nil)
        }

        sut.request(method: .get, path: .item(id: nil), data: dummyPatchingItem) { result in
            switch result {
            case .success:
                XCTFail("성공하면 안됨")
            case .failure(let error):
                XCTAssertEqual(error, .requestGETWithData)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }
}
