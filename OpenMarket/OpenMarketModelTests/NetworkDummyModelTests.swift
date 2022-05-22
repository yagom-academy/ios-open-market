//
//  OpenMarketModelTests.swift
//  OpenMarketModelTests
//
//  Created by Red, Mino on 2022/05/10.
//

import XCTest
@testable import OpenMarket

class NetworkDummyModelTests: XCTestCase {
    var sut: APIProvider<Products>!
    var itemURL = URL(string: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/5a0cd56b6d3411ecabfa97fd953cf965.jpg")
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = APIProvider<Products>(urlSession: StubURLSession())
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_request를호출할때_예상값을반환() {
        // given
        let promise = expectation(description: "TEST")
        guard let file = NSDataAsset(name: "products") else {
            return
        }
        
        let endPoint = EndPoint(
            baseURL: "TEST",
            sampleData: file.data
        )
        
        // when
        sut.request(with: endPoint) { result in
            switch result {
            case .success(let data):
                let result = data.pageNumber
                let expected = 1
                XCTAssertEqual(expected, result)
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
    
    func test_requestImage를호출할때_예상값을반환() {
        // given
        let promise = expectation(description: "TEST")
        
        // when
        sut.requestImage(with: itemURL!) { result in
            switch result {
            case .success(let data):
                let result = data
                do {
                    let expected = try Data(
                        contentsOf: URL(
                            string: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/5a0cd56b6d3411ecabfa97fd953cf965.jpg")!)
                    XCTAssertEqual(expected, result)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
}
