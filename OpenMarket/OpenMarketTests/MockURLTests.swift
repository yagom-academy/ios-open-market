//
//  MockURLTests.swift
//  OpenMarketTests
//
//  Created by 김민성 on 2021/06/07.
//

import XCTest
//import UIKit
@testable import OpenMarket


class MockURLTests: XCTestCase {
    var sut_GETProcess: DataLoader!
    let url = URL(string: "https://camp-open-market-2.herokuapp.com/item/55")!
    var expectation: XCTestExpectation!

    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        self.expectation = expectation(description: "Expectation")
        sut_GETProcess = DataLoader(commonURLProcess: CommonURLProcess(), urlSession: urlSession)
    }

    func test_MockURLProcess() {
        guard let abstractedAssetData = NSDataAsset(name: "Element", bundle: .main) else {
            XCTFail()
            return
        }
        
        let data = abstractedAssetData.data
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.url else {
                throw fatalError("unvalid URL")
            }
            
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response, data)
        }
            
            self.sut_GETProcess.startLoad(index: "55") { (testParam: Result<GetProductList.Item, Error>) in
                switch testParam {
                case .success(let post):
                    XCTAssertEqual(post.title, "MacBook Pro")
                case .failure(let error):
                    XCTFail()
                }
                self.expectation.fulfill()
            }
        wait(for: [self.expectation], timeout: 4.0)
        }
}
