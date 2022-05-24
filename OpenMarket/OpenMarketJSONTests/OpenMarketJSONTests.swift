//
//  OpenMarketJSONTests.swift
//  OpenMarketJSONTests
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import XCTest
@testable import OpenMarket

final class OpenMarketJSONTests: XCTestCase, NetworkAble {
    var session: URLSessionProtocol = URLSession.shared
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        session = URLSession.shared
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        session = URLSession.shared
    }
    
    func test_mockNetwork객체를_pageInformation_decoding해서_결과는_NotNil_그리고_page의_첫번째물건이름은_TestProduct() {
        // given
        let fileName = "PageInformationTest"
        let extensionType = "json"
        let pageNo = 1
        let imtesPerPage = 10
        guard let url = OpenMarketApi.pageInformation(pageNo: pageNo, itemsPerPage: imtesPerPage).url else {
            XCTFail("Url 변환 실패")
            return
        }
        let data = load(fileName: fileName, extensionType: extensionType)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: data, response: response, error: nil)
        let stubUrlSession = StubURLSession(dummy: dummy)
        session = stubUrlSession
        
        //when
        requestData(url: url) { (data, response) in
            guard let data = data,
                  let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }
            
            //then
            XCTAssertNotNil(pageInformation)
        }
        errorHandler: { error in
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_mockNetwork객체를_sessionError를_발생시켜서_확인() {
        // given
        let fileName = "PageInformationTest"
        let extensionType = "json"
        guard let url = OpenMarketApi.pageInformation(pageNo: 1, itemsPerPage: 10).url else { return }
        let data = load(fileName: fileName, extensionType: extensionType)
        let sessionError = NetworkError.sessionError
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: data, response: response, error: sessionError)
        let stubUrlSession = StubURLSession(dummy: dummy)

        session = stubUrlSession
        //when
        requestData(url: url) { (data, response) in
            XCTFail("complete handler 사용")
        } errorHandler: { error in
            XCTAssertEqual(error as? NetworkError, sessionError)
        }
    }
    
    func test_pageInformation_decoding해서_결과는_NotNil() {
        // given
        let promise = expectation(description: "timeout 테스트")
        let pageNo = 1
        let itemsPerPage = 10
        
        guard let url = OpenMarketApi.pageInformation(pageNo: pageNo, itemsPerPage: itemsPerPage).url else {
            XCTFail("변환실패")
            return
        }

        // when
        requestData(url: url) { (data, response) in
            guard let data = data,
                  let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }
            
            //then
            XCTAssertNotNil(pageInformation)
            promise.fulfill()
        }
        errorHandler: { error in
            XCTFail(error.localizedDescription)
        }
        wait(for: [promise], timeout: 10)
    }

    func test_productDetail_decoding해서_결과는_NotNil() {
        // given
        let promise = expectation(description: "timeout 테스트")
        let target = 2049
        guard let url = OpenMarketApi.productDetail(productNumber: target).url else {
            XCTFail("Url 변환 실패")
            return
        }
        
        // when
        requestData(url: url) { data, response in
            guard let data = data,
                  let productDetail = try? JSONDecoder().decode(ProductDetail.self, from: data) else { return }

        // then
            XCTAssertNotNil(productDetail)
            promise.fulfill()
        } errorHandler: { error in
            XCTFail(error.localizedDescription)
        }
        wait(for: [promise], timeout: 10)
    }
    
    func test_mockNetwork객체에_statusCodeError를_발생시켜서_확인() {
        // given
        let fileName = "PageInformationTest"
        let extensionType = "json"
        guard let url = OpenMarketApi.pageInformation(pageNo: 1, itemsPerPage: 10).url else { return }
        let statusCodeError = NetworkError.statusCodeError
        let data = load(fileName: fileName, extensionType: extensionType)
        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: data, response: response, error: nil)
        let stubUrlSession = StubURLSession(dummy: dummy)
        session = stubUrlSession
        
        //when
        requestData(url: url) { (data, response) in
            XCTFail("complete handler 사용")
        } errorHandler: { error in
            XCTAssertEqual(error as? NetworkError, statusCodeError)
        }
    }
    
    func test_mockNetwork객체에_dataError를_발생시켜서_확인() {
        // given
        guard let url = OpenMarketApi.pageInformation(pageNo: 1, itemsPerPage: 10).url else { return }
        let dataError = NetworkError.dataError
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: nil, response: response, error: nil)
        let stubUrlSession = StubURLSession(dummy: dummy)
        session = stubUrlSession
        
        //when
        requestData(url: url) { (data, response) in
            XCTFail("complete handler 사용")
        } errorHandler: { error in
            XCTAssertEqual(error as? NetworkError, dataError)
        }
    }
}

// MARK: - 파일 load 함수

private extension OpenMarketJSONTests {
    func load(fileName: String, extensionType: String) -> Data? {
        let testBundle = Bundle(for: type(of: self))
        guard let fileLocation = testBundle.url(forResource: fileName, withExtension: extensionType) else { return nil }
        do {
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            return nil
        }
    }
}
