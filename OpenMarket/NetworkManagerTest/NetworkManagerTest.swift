//
//  NetworkManagerTest.swift
//  NetworkManagerTest
//
//  Created by parkhyo on 2022/11/16.
//

import XCTest
@testable import OpenMarket

class NetworkManagerTest: XCTestCase {

    var sut: NetworkManager!
    var checkHealthURL: URL!
    var productListURL: URL!
    var productDetailURL: URL!
    var data: Data!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        checkHealthURL = NetworkRequest.checkHealth.requestURL
        productListURL = NetworkRequest.productList.requestURL
        productDetailURL = NetworkRequest.productDetail.requestURL
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        checkHealthURL = nil
        productListURL = nil
        productDetailURL = nil
        data = nil
    }
    
    func test_HealthCheck_요청시_statusCode가_200인지_확인() {
        data = Data(capacity: 1000) // 임의의 데이터
        let mockURLSession = MockURLSession.makeMockSenderSession(url: productDetailURL,
                                                 data: data,
                                                 statusCode: 200)
        
        sut = NetworkManager(session: mockURLSession)
        var intResult: Int?
        
        sut.checkHealth(to: checkHealthURL) { result in
            switch result {
            case .success(let data):
                intResult = data
            case .failure(_):
                print(result)
                intResult = nil
            }
        }
        
        XCTAssertEqual(intResult, 200)
    }
    
    func test_HealthCheck_요청시_statusCode가_200이_아닐때_오류_확인() {
        data = Data(capacity: 1000) // 임의의 데이터
        let mockURLSession = MockURLSession.makeMockSenderSession(url: checkHealthURL,
                                                 data: data,
                                                 statusCode: 300)
        
        sut = NetworkManager(session: mockURLSession)
        var intResult: Int?
        
        sut.checkHealth(to: checkHealthURL) { result in
            switch result {
            case .success(let data):
                intResult = data
            case .failure(_):
                print(result)
                intResult = nil
            }
        }
        
        XCTAssertFalse(intResult == 200)
    }
    
    
    func test_productList_요청시_받아온_Data가_nil이_아닌지_확인() {
        data = TestData.productListData
        let mockURLSession = MockURLSession.makeMockSenderSession(url: productListURL,
                                                        data: data,
                                                 statusCode: 200)
        
        sut = NetworkManager(session: mockURLSession)
        var fetchDataResult: ProductPage?
        
        sut.fetchData(to: productListURL, dataType: ProductPage.self) { result in
            switch result {
            case .success(let data):
                fetchDataResult = data
            case .failure(_):
                fetchDataResult = nil
            }
        }
        
        XCTAssertTrue(fetchDataResult != nil)
    }
    
    func test_productList_요청시_statusCode가_200번대가_아닐때_오류_발생하는지__확인() {
        data = TestData.productListData
        let mockURLSession = MockURLSession.makeMockSenderSession(url: productListURL,
                                                        data: data,
                                                 statusCode: 400)
        
        sut = NetworkManager(session: mockURLSession)
        var fetchDataResult: ProductPage?
        
        sut.fetchData(to: productListURL, dataType: ProductPage.self) { result in
            switch result {
            case .success(let data):
                fetchDataResult = data
            case .failure(_):
                fetchDataResult = nil
            }
        }
        
        XCTAssertTrue(fetchDataResult == nil)
    }
    
    func test_productDetail_요청시_받아온_Data가_nil이_아닌지_확인() {
        data = TestData.productDetailData
        let mockURLSession = MockURLSession.makeMockSenderSession(url: productDetailURL,
                                                        data: data,
                                                 statusCode: 200)
        
        sut = NetworkManager(session: mockURLSession)
        var fetchDataResult: Product?
        
        sut.fetchData(to: productListURL, dataType: Product.self) { result in
            switch result {
            case .success(let data):
                fetchDataResult = data
            case .failure(_):
                fetchDataResult = nil
            }
        }

        XCTAssertTrue(fetchDataResult != nil)
    }
    
    func test_productDetail_요청시_statusCode가_200번대가_아닐때_오류_발생하는지__확인() {
        data = TestData.productDetailData
        let mockURLSession = MockURLSession.makeMockSenderSession(url: productDetailURL,
                                                        data: data,
                                                 statusCode: 400)
        
        sut = NetworkManager(session: mockURLSession)
        var fetchDataResult: Product?
        
        sut.fetchData(to: productListURL, dataType: Product.self) { result in
            switch result {
            case .success(let data):
                fetchDataResult = data
            case .failure(_):
                fetchDataResult = nil
            }
        }

        XCTAssertTrue(fetchDataResult == nil)
    }
}
