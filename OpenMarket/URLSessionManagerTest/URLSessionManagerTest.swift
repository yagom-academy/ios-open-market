//
//  MockURLSessionTests.swift
//  MockURLSessionTests
//
//  Created by 주디, 재재 on 2022/07/12.
//

import XCTest

@testable import OpenMarket

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    var newResume: () -> Void = {}
    
    func resume() {
        newResume()
    }
}

final class MockURLSession: URLSessionProtocol {
    var isSuccess: Bool
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        var success: HTTPURLResponse?
        var failure: HTTPURLResponse?
        
        if let url = request.url {
            success = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2.0", headerFields: nil)
            failure = HTTPURLResponse(url: url, statusCode: 404, httpVersion: "2.0", headerFields: nil)
        }
        
        let mockURLSessionDataTask = MockURLSessionDataTask()
        
        if isSuccess {
            let mockData = NSDataAsset.init(name: "MockData")?.data
            mockURLSessionDataTask.newResume = {
                completionHandler(mockData, success, nil)
            }
        } else {
            mockURLSessionDataTask.newResume = {
                completionHandler(nil, failure, nil)
            }
        }
        return mockURLSessionDataTask
    }
}

class MockURLSessionTests: XCTestCase {
    let dataDecoder = DataDecoder()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func test_receivePage_서버요청이_성공한경우에_받아온Json데이터가_MockData와같은지() {
        let mockURLSession = MockURLSession(isSuccess: true)
        let sut = URLSessionManager(session: mockURLSession)
        let subURL = SubURL().pageURL(number: 1, countOfItems: 20)
        
        guard let mockData = NSDataAsset.init(name: "MockData")?.data,
              let page = dataDecoder.decode(type: Page.self, data: mockData) else { return }
        
        sut.receivePage(subURL: subURL) { result in
            switch result {
            case .success(let data):
                let responsedData = self.dataDecoder.decode(type: Page.self, data: data)
                XCTAssertEqual(responsedData?.pageNumber, page.pageNumber)
                XCTAssertEqual(responsedData?.itemsPerPage, page.itemsPerPage)
            case .failure(_):
                XCTFail("서버 데이터 불일치 오류")
            }
        }
    }
    
    func test_receivePage_서버요청이_실패한경우에_에러를반환하는지() {
        let mockURLSession = MockURLSession(isSuccess: false)
        let sut = URLSessionManager(session: mockURLSession)
        let subURL = SubURL().pageURL(number: 1, countOfItems: 20)
        
        sut.receivePage(subURL: subURL) { result in
            switch result {
            case .success(_):
                XCTFail("서버 요청이 실패하지 않은 오류")
            case .failure(let error):
                XCTAssertEqual(error, DataTaskError.incorrectResponse)
            }
        }
    }
    
    func test_receivePage_실제로서버요청을했을때_2번페이지데이터를_받아올수있는지() {
        let sut = URLSessionManager(session: URLSession.shared)
        let subURL = SubURL().pageURL(number: 2, countOfItems: 10)
        
        sut.receivePage(subURL: subURL) { result in
            switch result {
            case .success(let data):
                let responsedData = self.dataDecoder.decode(type: Page.self, data: data)
                XCTAssertEqual(responsedData?.totalCount, 325)
            case .failure(_):
                XCTFail("서버 데이터 불일치 오류")
            }
        }
    }
}
