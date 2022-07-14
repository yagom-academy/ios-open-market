//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by unchain, hyeon2 on 2022/07/12.
//

import XCTest

class OpenMarketTests: XCTestCase {
    var sut: NetworkManager?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_fetchData_Data가_있고_statusCode가_200일때() {
        // given
        let url = "https://market-training.yagom-academy.kr/"
        let mockResponse: MockURLSession.Response = {
            let data = NSDataAsset(name: "products", bundle: .main)?.data
            let successResponse = HTTPURLResponse(url: URL(string: url)!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
            return (data: data,
                    urlResponse: successResponse,
                    error: nil)
        }()
        let mockURLSession = MockURLSession(response: mockResponse)
        let sut = NetworkManager(session: mockURLSession)
        
        // when
        var result: MarketInformation?
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        sut.fetch(request: request,
                  dataType: MarketInformation.self) { response in
            if case let .success(product) = response {
                result = product
                
                // then
                guard let data = NSDataAsset(name: "products")?.data else {
                    return
                }
                
                let expectation = try? JSONDecoder().decode(MarketInformation.self, from: data)
                
                XCTAssertEqual(result?.pageNo, expectation?.pageNo)
            }
        }
    }
    
    func test_fetchData_statusCode가_200이고_원하는_값이_아닐때() {
        // given
        struct MarketInformationTest: Decodable {
            let pageNo: Int
        }
        
        let url = "https://market-training.yagom-academy.kr/"
        let mockResponse: MockURLSession.Response = {
            let data = NSDataAsset(name: "products", bundle: .main)?.data
            let successResponse = HTTPURLResponse(url: URL(string: url)!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
            return (data: data,
                    urlResponse: successResponse,
                    error: nil)
        }()
        let mockURLSession = MockURLSession(response: mockResponse)
        let sut = NetworkManager(session: mockURLSession)
        
        // when
        var result: MarketInformation?
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        sut.fetch(request: request,
                  dataType: MarketInformation.self) { response in
            if case let .success(product) = response {
                result = product
                
                // then
                guard let data = NSDataAsset(name: "products")?.data else {
                    return
                }
                
                let expectation = try? JSONDecoder().decode(MarketInformationTest.self, from: data)
                
                XCTAssertEqual(result?.pageNo, expectation?.pageNo)
            }
        }
    }
    
    func test_fetchData_Data가_있고_statusCode가_500일때() {
        // given
        let url = "https://market-training.yagom-academy.kr/"
        let mockResponse: MockURLSession.Response = {
            let data = NSDataAsset(name: "products", bundle: .main)?.data
            let successResponse = HTTPURLResponse(url: URL(string: url)!,
                                                  statusCode: 500,
                                                  httpVersion: nil,
                                                  headerFields: nil)
            return (data: data,
                    urlResponse: successResponse,
                    error: nil)
        }()
        let mockURLSession = MockURLSession(response: mockResponse)
        let sut = NetworkManager(session: mockURLSession)
        
        // when
        var result: Error?
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        sut.fetch(request: request,
                  dataType: MarketInformation.self) { response in
            if case let .failure(error) = response {
                result = error
                XCTAssertNotNil(result)
            }
        }
    }
}
