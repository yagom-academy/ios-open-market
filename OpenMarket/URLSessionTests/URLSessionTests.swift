//
//  URLSessionTests.swift
//  URLSessionTests
//
//  Created by Ayaan on 2022/11/16.
//

import Foundation
import XCTest

typealias DataTaskCompletion = (Data?, URLResponse?, Error?) -> Void

class URLSessionTests: XCTestCase {
    var sut: FakeURLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = FakeURLSession()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test_GivenDataAndHTTPStatus200_WhenFetchedHealth_ThenResultIsOK() {
        //given
        let promise = expectation(description: "OpenMarketHealthChecker")
        let url = URL(string: "https://openmarket.yagom-academy.kr/")
        let data = "ok".data(using: .utf8)
        let response = HTTPURLResponse(url: url!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let dummyData = RequestedDummyData(data: data, response: response, error: nil)
        
        sut.stubURLSession = StubURLSession(dummy: dummyData)
        
        //when
        sut.fetchHealth { (health) in
            //then
            XCTAssertEqual(health, OpenMarketHealth.ok)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func test_GivenOnlyBadStatusError_WhenFetchedHealth_ThenResultIsBad() {
        let promise = expectation(description: "OpenMarketHealthChecker")
        let dummyData = RequestedDummyData(data: nil, response: nil, error: OpenMarketError.badStatus)
        
        sut.stubURLSession = StubURLSession(dummy: dummyData)
        
        sut.fetchHealth { (health) in
            XCTAssertEqual(health, OpenMarketHealth.bad)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func test_GivenOnlyHTTPStatus404_WhenFetchedHealth_ThenResultIsBad() {
        let promise = expectation(description: "OpenMarketHealthChecker")
        let url = URL(string: "https://openmarket.yagom-academy.kr/")
        let response = HTTPURLResponse(url: url!,
                                       statusCode: 404,
                                       httpVersion: nil,
                                       headerFields: nil)
        let dummyData = RequestedDummyData(data: nil, response: response, error: nil)
        
        sut.stubURLSession = StubURLSession(dummy: dummyData)
        
        sut.fetchHealth { (health) in
            XCTAssertEqual(health, OpenMarketHealth.bad)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func test_GivenDataAndHTTPStatus200_WhenFetchedPage_ThenResultIsNotNil() {
        //given
        let promise = expectation(description: "OpenMarketFetchPage")
        let url = URL(string: "https://openmarket.yagom-academy.kr/")
        let data = NSDataAsset(name: "products")?.data
        let response = HTTPURLResponse(url: url!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let dummyData = RequestedDummyData(data: data, response: response, error: nil)
        
        sut.stubURLSession = StubURLSession(dummy: dummyData)
        
        //when
        sut.fetchPage(pageNumber: 1, productsPerPage: 10) { (page) in
            //then
            XCTAssertNotNil(page)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func test_GivenOnlyBadStatusError_WhenFetchedPage_ThenResultIsNil() {
        //given
        let promise = expectation(description: "OpenMarketFetchPage")
        let dummyData = RequestedDummyData(data: nil, response: nil, error: OpenMarketError.badStatus)
        
        sut.stubURLSession = StubURLSession(dummy: dummyData)
        
        //when
        sut.fetchPage(pageNumber: 1, productsPerPage: 10) { (page) in
            //then
            XCTAssertNil(page)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func test_GivenOnlyHTTPStatus404_WhenFetchedPage_ThenResultIsNil() {
        //given
        let promise = expectation(description: "OpenMarketFetchPage")
        let url = URL(string: "https://openmarket.yagom-academy.kr/")
        let response = HTTPURLResponse(url: url!,
                                       statusCode: 404,
                                       httpVersion: nil,
                                       headerFields: nil)
        let dummyData = RequestedDummyData(data: nil, response: response, error: nil)
        
        sut.stubURLSession = StubURLSession(dummy: dummyData)
        
        //when
        sut.fetchPage(pageNumber: 1, productsPerPage: 10) { (page) in
            //then
            XCTAssertNil(page)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func test_GivenDataAndHTTPStatus200_WhenFetchedProduct_ThenResultIsNotNil() {
        //given
        let promise = expectation(description: "OpenMarketFetchProduct")
        let url = URL(string: "https://openmarket.yagom-academy.kr/")
        let data = NSDataAsset(name: "product")?.data
        let response = HTTPURLResponse(url: url!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let dummyData = RequestedDummyData(data: data, response: response, error: nil)
        
        sut.stubURLSession = StubURLSession(dummy: dummyData)
        
        //when
        sut.fetchProduct(productNumber: 32) { (product) in
            //then
            XCTAssertNotNil(product)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func test_GivenOnlyBadStatusError_WhenFetchedProduct_ThenResultIsNil() {
        //given
        let promise = expectation(description: "OpenMarketFetchProduct")
        let dummyData = RequestedDummyData(data: nil, response: nil, error: OpenMarketError.badStatus)
        
        sut.stubURLSession = StubURLSession(dummy: dummyData)
        
        //when
        sut.fetchProduct(productNumber: 32) { (product) in
            //then
            XCTAssertNil(product)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func test_GivenOnlyHTTPStatus404_WhenFetchedProduct_ThenResultIsNil() {
        //given
        let promise = expectation(description: "OpenMarketFetchProduct")
        let url = URL(string: "https://openmarket.yagom-academy.kr/")
        let response = HTTPURLResponse(url: url!,
                                       statusCode: 404,
                                       httpVersion: nil,
                                       headerFields: nil)
        let dummyData = RequestedDummyData(data: nil, response: response, error: nil)
        
        sut.stubURLSession = StubURLSession(dummy: dummyData)
        
        //when
        sut.fetchProduct(productNumber: 32) { (product) in
            //then
            XCTAssertNil(product)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
}
