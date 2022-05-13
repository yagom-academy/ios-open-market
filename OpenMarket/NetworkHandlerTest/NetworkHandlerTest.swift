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
    func test_getData호출시_decodeItemPage성공시_0번째items의_id가_20인가() {
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
                let itemPage = try DataDecoder.decode(data: data, dataType: ItemPage.self)
                XCTAssertEqual(itemPage.items[0].id, 20)
            } catch {
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_getData호출시_path가_올바르지않을경우_convertError를_잘던지는지() {
        //given
        let promise = expectation(description: "convertError를_잘던지는지")
        let testPath = "te st"
        var dummyData = DummyData()
        dummyData.data = convertJsonToData(fileName: "products")
        dummyData.response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: "2", headerFields: nil)
        dummyData.error = nil
        sut.session = StubURLSession(dummyData: dummyData)

        //when
        sut.getData(pathString: testPath) { data in
            //then
            do {
                let _ = try DataDecoder.decode(data: data, dataType: ItemPage.self)
                XCTFail()
            } catch {
                XCTAssertEqual(error as! APIError, APIError.convertError)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }

    func test_getData호출시_dataTask에서_에러가존재할경우_requestError를_잘던지는지() {
        //given
        let promise = expectation(description: "requestError를_잘던지는지")
        var dummyData = DummyData()
        dummyData.data = convertJsonToData(fileName: "products")
        dummyData.response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: "2", headerFields: nil)
        dummyData.error = APIError.convertError
        sut.session = StubURLSession(dummyData: dummyData)

        //when
        sut.getData(pathString: "test") { data in
            //then
            do {
                let _ = try DataDecoder.decode(data: data, dataType: ItemPage.self)
                XCTFail()
            } catch {
                XCTAssertEqual(error as! APIError, APIError.transportError)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }

    func test_getData호출시_statusCode가_200에서299_아닐때_responseError를_잘던지는지() {
        //given
        let promise = expectation(description: "responseError를_잘던지는지")
        var dummyData = DummyData()
        dummyData.data = convertJsonToData(fileName: "products")
        dummyData.response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 404, httpVersion: "2", headerFields: nil)
        dummyData.error = nil
        sut.session = StubURLSession(dummyData: dummyData)

        //when
        sut.getData(pathString: "test") { data in
            //then
            do {
                let _ = try DataDecoder.decode(data: data, dataType: ItemPage.self)
                XCTFail()
            } catch {
                XCTAssertEqual(error as! APIError, APIError.responseError)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }

    func test_getData호출시_data가_올바르지않은경우_dataError를_잘던지는지() {
        //given
        let promise = expectation(description: "dataError를_잘던지는지")
        var dummyData = DummyData()
        dummyData.data = nil
        dummyData.response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: "2", headerFields: nil)
        dummyData.error = nil
        sut.session = StubURLSession(dummyData: dummyData)

        //when
        sut.getData(pathString: "test") { data in
            //then
            do {
                let _ = try DataDecoder.decode(data: data, dataType: ItemPage.self)
                XCTFail()
            } catch {
                XCTAssertEqual(error as! APIError, APIError.dataError)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }

    func test_getData호출시_decoding실패시_decodeError를_잘던지는지() {
        //given
        let promise = expectation(description: "decodeError를_잘던지는지")
        let testFileName = "wrongFileName"
        var dummyData = DummyData()
        dummyData.data = convertJsonToData(fileName: testFileName)
        dummyData.response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: "2", headerFields: nil)
        dummyData.error = nil
        sut.session = StubURLSession(dummyData: dummyData)

        //when
        sut.getData(pathString: "test") { data in
            //then
            do {
                let _ = try DataDecoder.decode(data: data, dataType: ItemPage.self)
                XCTFail()
            } catch {
                XCTAssertEqual(error as! APIError, APIError.decodeError)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
}
