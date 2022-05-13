//
//  OpenMarketJSONTests.swift
//  OpenMarketJSONTests
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import XCTest
@testable import OpenMarket

final class OpenMarketJSONTests: XCTestCase {
    private var network: NetworkAble!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        network = Network(session: URLSession.shared)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        network = nil
    }
    
    func test_testMock() {
        // given
        let fileName = "PageInformationTest"
        let extensionType = "json"
        
        let promise = expectation(description: "")
        let url = URL(string: OpenMarketApi.pageInformation(pageNo: 1, itemsPerPage: 10).string)!
        
        let data = load(fileName: fileName, extensionType: extensionType)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let completionHandler = { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data,
                  let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }

            XCTAssertNotNil(pageInformation)
            promise.fulfill()
            
//            print(pageInformation.pages.description)
        }
        let errorHandler = { (error: Error) -> Void in
            print(error)
        }
        
        let dummy = DummyData(data: data, response: response, error: nil, completionHandler: completionHandler)
        let stubUrlSession = StubURLSession(dummy: dummy)
        
        let mockNetwork = Network(session: stubUrlSession)
        
        
        mockNetwork.requestData(url: OpenMarketApi.pageInformation(pageNo: 1, itemsPerPage: 10).string, completeHandler: completionHandler, errorHandler: errorHandler)
        
        // then
        
        // when
        wait(for: [promise], timeout: 10)
    }
    
    private func load(fileName: String, extensionType: String) -> Data? {
        let testBundle = Bundle(for: type(of: self))
        guard let fileLocation = testBundle.url(forResource: fileName, withExtension: extensionType) else { return nil }
        do {
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            return nil
        }
    }
    
//    func test_products_JSON_테스트파일을_decoding해서_결과는_NotNil() {
//        // given
//        let promise = expectation(description: "비동기 메서드 테스트")
//        let pageNo = 2
//        let itemsPerPage = 10
//        let url = OpenMarketApi.pageInformation(pageNo: pageNo, itemsPerPage: itemsPerPage).string
//
//        // when
//        mockNetwork.requestData(url: url) { data, response, error in
//            guard error == nil else { return }
//
//            guard let data = data,
//                  let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }
//
//        // then
//            XCTAssertNotNil(pageInformation)
//            promise.fulfill()
//        }
//        wait(for: [promise], timeout: 10)
//    }
    
//    func test_pageInformation_decoding해서_결과는_NotNil() {
//        // given
//        let promise = expectation(description: "비동기 메서드 테스트")
//        let pageNo = 2
//        let itemsPerPage = 10
//        let url = OpenMarketApi.pageInformation(pageNo: pageNo, itemsPerPage: itemsPerPage).string
//
//        // when
//        network.requestData(url: url) { data, response, error in
//            guard error == nil else { return }
//
//            let successsRange = 200..<300
//
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
//                    successsRange.contains(statusCode) else { return }
//
//            guard let data = data,
//                  let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }
//
//        // then
//            XCTAssertNotNil(pageInformation)
//            promise.fulfill()
//        }
//        wait(for: [promise], timeout: 10)
//    }
//
//    func test_productDetail_decoding해서_결과는_NotNil() {
//        // given
//        let promise = expectation(description: "비동기 메서드 테스트")
//        let target = 2049
//        let url = OpenMarketApi.productDetail(productNumber: target).string
//
//        // when
//        network.requestData(url: url) { data, response, error in
//            guard error == nil else { return }
//
//            let successsRange = 200..<300
//
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
//                    successsRange.contains(statusCode) else { return }
//
//            guard let data = data,
//                  let productDetail = try? JSONDecoder().decode(ProductDetail.self, from: data) else { return }
//
//        // then
//            XCTAssertNotNil(productDetail)
//            promise.fulfill()
//        }
//        wait(for: [promise], timeout: 10)
//    }
}

