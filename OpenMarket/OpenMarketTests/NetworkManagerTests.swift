//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by unchain, hyeon2 on 2022/07/12.
//

import XCTest

class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_GET메서드를_요청한경우_parsing을_제대로한다() {
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
    
    func test_GET메서드를_요청한경우_서버매핑모델이_달라서_parsing에_실패한다() {
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
    
    func test_GET메서드_요청시_statusCode가_500이면_error를_반환한다() {
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
