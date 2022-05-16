//
//  NetworkHandlerTest.swift
//  NetworkHandlerTest
//
//  Created by 두기, minseong on 2022/05/11.
//

import XCTest
@testable import OpenMarket

class NetworkHandlerTest: XCTestCase {
    
    //MARK: - 테스트를 위한 메서드
    func convertJsonToData(fileName: String) -> Data {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: fileName, ofType: "json")
        let jsonString = try? String(contentsOfFile: path ?? "")
        return jsonString?.data(using: .utf8) ?? Data()
    }
    
    func makeDummyData(data: Data?, statusCode: Int, error: Error?) -> ResponseResult {
        let rsponse = HTTPURLResponse(url: URL(string: "test")!, statusCode: statusCode, httpVersion: "2", headerFields: nil)
        return ResponseResult(data: data, response: rsponse, error: error)
    }
    
    //MARK: - 네트워크 없이 테스트
    func test_communicate호출시_ItemPage타입으로_decode성공시_0번째items의_id가_20인가() {
        //given
        let promise = expectation(description: "id가 일치 하는지")
        let data = convertJsonToData(fileName: "products")
        let dummyData = makeDummyData(data: data, statusCode: 200, error: nil)
        let netWorkHandler = NetworkHandler(session: StubURLSession(dummyData: dummyData))
        
        //when
        netWorkHandler.request(pathString: "test", httpMethod: .get) { data in
            switch data {
            case .success(let data):
                do {
                    let data = try DataDecoder.decode(data: data, dataType: ItemPage.self)
                    //then
                    XCTAssertEqual(data.items[0].id, 20)
                } catch {
                    XCTFail()
                }
            case .failure(_):
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_communicate호출시_path가_올바르지않을경우_convertError를_잘던지는지() {
        //given
        let promise = expectation(description: "id가 일치 하는지")
        let data = convertJsonToData(fileName: "products")
        let dummyData = makeDummyData(data: data, statusCode: 200, error: nil)
        let netWorkHandler = NetworkHandler(session: StubURLSession(dummyData: dummyData))
        let wrongURLString = "te st"
        
        //when
        netWorkHandler.request(pathString: wrongURLString, httpMethod: .get) { data in
            switch data {
            case .success(let data):
                do {
                    let _ = try DataDecoder.decode(data: data, dataType: ItemPage.self)
                    XCTFail()
                } catch {
                    XCTFail()
                }
            case .failure(let error):
                //then
                XCTAssertEqual(error, APIError.convertError)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_communicate호출시_request과정에서에러가발생할경우_transportError를_잘던지는지() {
        //given
        let promise = expectation(description: "id가 일치 하는지")
        let data = convertJsonToData(fileName: "products")
        let dummyData = makeDummyData(data: data, statusCode: 200, error: APIError.convertError)
        let netWorkHandler = NetworkHandler(session: StubURLSession(dummyData: dummyData))
        
        //when
        netWorkHandler.request(pathString: "test", httpMethod: .get) { data in
            switch data {
            case .success(let data):
                do {
                    let _ = try DataDecoder.decode(data: data, dataType: ItemPage.self)
                    XCTFail()
                } catch {
                    XCTFail()
                }
            case .failure(let error):
                //then
                XCTAssertEqual(error, APIError.transportError)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_communicate호출시_statusCode가_200에서299_아닐때_responseError를_잘던지는지() {
        //given
        let promise = expectation(description: "id가 일치 하는지")
        let data = convertJsonToData(fileName: "products")
        let dummyData = makeDummyData(data: data, statusCode: 404, error: nil)
        let netWorkHandler = NetworkHandler(session: StubURLSession(dummyData: dummyData))
        
        //when
        netWorkHandler.request(pathString: "test", httpMethod: .get) { data in
            switch data {
            case .success(let data):
                do {
                    let _ = try DataDecoder.decode(data: data, dataType: ItemPage.self)
                    XCTFail()
                } catch {
                    XCTFail()
                }
            case .failure(let error):
                //then
                XCTAssertEqual(error, APIError.responseError)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_communicate호출시_data가_올바르지않은경우_dataError를_잘던지는지() {
        //given
        let promise = expectation(description: "id가 일치 하는지")
        let dummyData = makeDummyData(data: nil, statusCode: 200, error: nil)
        let netWorkHandler = NetworkHandler(session: StubURLSession(dummyData: dummyData))
        
        //when
        netWorkHandler.request(pathString: "test", httpMethod: .get) { data in
            switch data {
            case .success(let data):
                do {
                    let _ = try DataDecoder.decode(data: data, dataType: ItemPage.self)
                    XCTFail()
                } catch {
                    //then
                    XCTAssertEqual(error as! APIError, APIError.dataError)
                }
            case .failure(_):
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_communicate호출시_decoding실패시_decodeError를_잘던지는지() {
        //given
        let promise = expectation(description: "id가 일치 하는지")
        let wrongFileName = "test"
        let data = convertJsonToData(fileName: wrongFileName)
        let dummyData = makeDummyData(data: data, statusCode: 200, error: nil)
        let netWorkHandler = NetworkHandler(session: StubURLSession(dummyData: dummyData))
        
        //when
        netWorkHandler.request(pathString: "test", httpMethod: .get) { data in
            switch data {
            case .success(let data):
                do {
                    let _ = try DataDecoder.decode(data: data, dataType: ItemPage.self)
                    XCTFail()
                } catch {
                    //then
                    XCTAssertEqual(error as! APIError, APIError.decodeError)
                }
            case .failure(_):
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
}
