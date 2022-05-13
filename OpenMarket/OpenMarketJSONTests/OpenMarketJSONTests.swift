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
    
    func test_mockNetwork객체를_pageInformation_decoding해서_결과는_NotNil_그리고_page의_첫번째물건이름은_TestProduct() {
        // given
        let fileName = "PageInformationTest"
        let extensionType = "json"
        let promise = expectation(description: "timeout 테스트")
        let url = URL(string: OpenMarketApi.pageInformation(pageNo: 1, itemsPerPage: 10).string)!
        let data = load(fileName: fileName, extensionType: extensionType)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: data, response: response, error: nil)
        let stubUrlSession = StubURLSession(dummy: dummy)
        let mockNetwork = Network(session: stubUrlSession)
        
        //when
        mockNetwork.requestData(url: OpenMarketApi.pageInformation(pageNo: 1, itemsPerPage: 10).string)
        { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data,
                  let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }
            
            //then
            XCTAssertNotNil(pageInformation)
            XCTAssertEqual(pageInformation.pages.first?.name, "Test Product" )
            promise.fulfill()
        }
    errorHandler: { (error: Error) -> Void in
        print(error)
        XCTFail()
    }
        wait(for: [promise], timeout: 10)
    }
    
    func test_mockNetwork객체를_sessionError를_발생시켜서_확인() {
        // given
        let fileName = "PageInformationTest"
        let extensionType = "json"
        let promise = expectation(description: "timeout 테스트")
        let url = URL(string: OpenMarketApi.pageInformation(pageNo: 1, itemsPerPage: 10).string)!
        let data = load(fileName: fileName, extensionType: extensionType)
        let sessionError = NetworkError.sessionError
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: data, response: response, error: sessionError)
        let stubUrlSession = StubURLSession(dummy: dummy)
        let mockNetwork = Network(session: stubUrlSession)
        
        //when
        mockNetwork.requestData(url: OpenMarketApi.pageInformation(pageNo: 1, itemsPerPage: 10).string) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data,
                  let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }
            
            //then
            XCTAssertNotNil(pageInformation)
            XCTAssertEqual(pageInformation.pages.first?.name, "Test Product" )
            promise.fulfill()
        } errorHandler: { (error: Error) -> Void in
            XCTAssertEqual(error as? NetworkError, sessionError)
            promise.fulfill()
        }
        
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
    
    func test_pageInformation_decoding해서_결과는_NotNil() {
        // given
        let promise = expectation(description: "비동기 메서드 테스트")
        let pageNo = 2
        let itemsPerPage = 10
        let url = OpenMarketApi.pageInformation(pageNo: pageNo, itemsPerPage: itemsPerPage).string

        // when
        network.requestData(url: url) { data, response, error in
            guard error == nil else { return }

            let successsRange = 200..<300

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    successsRange.contains(statusCode) else { return }

            guard let data = data,
                  let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }

        // then
            XCTAssertNotNil(pageInformation)
            promise.fulfill()
        } errorHandler: { (error: Error) -> Void in
            print(error)
            XCTFail()
        }
        
        wait(for: [promise], timeout: 10)
    }

    func test_productDetail_decoding해서_결과는_NotNil() {
        // given
        let promise = expectation(description: "비동기 메서드 테스트")
        let target = 2049
        let url = OpenMarketApi.productDetail(productNumber: target).string

        // when
        network.requestData(url: url) { data, response, error in
            guard error == nil else { return }

            let successsRange = 200..<300

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    successsRange.contains(statusCode) else { return }

            guard let data = data,
                  let productDetail = try? JSONDecoder().decode(ProductDetail.self, from: data) else { return }

        // then
            XCTAssertNotNil(productDetail)
            promise.fulfill()
        } errorHandler: { (error: Error) -> Void in
            print(error)
            XCTFail()
        }
        
        wait(for: [promise], timeout: 10)
    }
}

