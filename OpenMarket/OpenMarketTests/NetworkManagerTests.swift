//
//  NetworkManagerTests.swift
//  OpenMarketTests
//
//  Created by Gundy, Wonbi on 2022/11/16.
//

import XCTest
@testable import OpenMarket

final class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager!
    let productListRequest: ProductListRequest = .init(pageNo: 1, itemsPerPage: 20)
    var dummyData: DummyData = .init(data: nil, response: nil, error: nil)

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = .init()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
        dummyData.data = nil
        dummyData.response = nil
        dummyData.error = nil
    }
    
    func test_dummyData에_Data가있고_statusCode가200일때_fetchData가_정상작동하는지() {
        // given
        guard let url = productListRequest.urlComponents,
              let data = DataLoader.data(fileName: "products") else { return }
        
        let mockURLSession: MockURLSession = {
            let response: HTTPURLResponse? = HTTPURLResponse(url: url,
                                                            statusCode: 200,
                                                            httpVersion: nil,
                                                            headerFields: nil)
            dummyData.data = data
            dummyData.response = response
            return MockURLSession(dummy: dummyData)
        }()
        sut.session = mockURLSession
        
        // when
        var result: ProductList?
        sut.fetchData(for: url, dataType: ProductList.self) { response in
            if case let .success(productList) = response {
                result = productList
            }
        }
        let expectation: ProductList? = JSONDecoder.decode(ProductList.self, from: data)
        
        // then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.pages.count, expectation?.pages.count)
    }
    
    func test_잘못된dataType을넘겼을때_failToParse에러를반환하는지() {
        // given
        guard let url = productListRequest.urlComponents,
              let data = DataLoader.data(fileName: "products") else { return }
        
        let mockURLSession: MockURLSession = {
            let response: HTTPURLResponse? = HTTPURLResponse(url: url,
                                                            statusCode: 200,
                                                            httpVersion: nil,
                                                            headerFields: nil)
            dummyData.data = data
            dummyData.response = response
            return MockURLSession(dummy: dummyData)
        }()
        sut.session = mockURLSession
        
        // when
        var result: NetworkError?
        sut.fetchData(for: url, dataType: Product.self) { response in
            if case let .failure(error) = response {
                result = error as? NetworkError
            }
        }
        let expectation: NetworkError = .failToParse
        
        // then
        XCTAssertEqual(result, expectation)
    }
    
    func test_data가없고_statusCode가400일때_invalid에러를반환하는지() {
        // given
        guard let url = productListRequest.urlComponents else { return }
        
        let mockURLSession: MockURLSession = {
            let response: HTTPURLResponse? = HTTPURLResponse(url: url,
                                                            statusCode: 400,
                                                            httpVersion: nil,
                                                            headerFields: nil)
            dummyData.response = response
            return MockURLSession(dummy: dummyData)
        }()
        sut.session = mockURLSession
        
        // when
        var result: NetworkError?
        sut.fetchData(for: url, dataType: ProductList.self) { response in
            if case let .failure(error) = response {
                result = error as? NetworkError
            }
        }
        let expectation: NetworkError = .invalid
        
        // then
        XCTAssertEqual(result, expectation)
    }
    
    func test_dummyData에에러가있을때_에러를반환하는지() {
        // given
        guard let url = productListRequest.urlComponents,
              let data = DataLoader.data(fileName: "products") else { return }
        
        let mockURLSession: MockURLSession = {
            let response: HTTPURLResponse? = HTTPURLResponse(url: url,
                                                            statusCode: 200,
                                                            httpVersion: nil,
                                                            headerFields: nil)
            dummyData.data = data
            dummyData.response = response
            dummyData.error = NetworkError.failRequest
            return MockURLSession(dummy: dummyData)
        }()
        sut.session = mockURLSession
        
        // when
        var result: NetworkError?
        sut.fetchData(for: url, dataType: ProductList.self) { response in
            if case let .failure(error) = response {
                result = error as? NetworkError
            }
        }
        let expectation: NetworkError = .failRequest
        
        // then
        XCTAssertEqual(result, expectation)
    }
}
