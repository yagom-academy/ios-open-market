//
//  NetworkHandlerTest.swift
//  NetworkHandlerTest
//
//  Created by 두기, minseong on 2022/05/11.
//

import XCTest
@testable import OpenMarket

class NetworkHandlerTest: XCTestCase {
    var sut: NetworkHandler!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkHandler()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    //MARK: - 테스트를 위한 메서드
    func convertJsonToData(fileName: String) -> Data {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: fileName, ofType: "json")
        let jsonString = try? String(contentsOfFile: path ?? "")
        return jsonString?.data(using: .utf8) ?? Data()
    }
    
    //MARK: - 네트워크 없이 테스트
    func test_getData호출시_데이터를잘가져오는지() {
        //given
        let promise = expectation(description: "id가 일치 하는지")
        var dummyData = DummyData()
        dummyData.data = convertJsonToData(fileName: "products")
        dummyData.response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: "2", headerFields: nil)
        dummyData.error = nil
        sut.session = StubURLSession(dummyData: dummyData)
        
        //when
        sut.getData(pathString: "test") { data in
            //then
            do {
                let itemPage = try DataDecoder.decodeItemPage(data: data)
                XCTAssertEqual(itemPage.items[0].id, 20)
            } catch {
                XCTAssertNil(error)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
}
