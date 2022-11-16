//
//  OpenMarket - MockURLSessionTests.swift
//  Created by Zhilly, Dragon. 22/11/16
//  Copyright © yagom. All rights reserved.
//

import XCTest
@testable import OpenMarket

class MockURLSessionTests: XCTestCase {
    let mockSession = MockURLSession()
    var sut: NetworkManager!
    
    override func setUpWithError() throws {
        sut = .init(session: mockSession)
    }
    
    func test_getItemList_success() {
        // 결과 data가 Json 형태라면
        _ = try? JSONDecoder().decode(ProductList.self, from: MockData().data)
        
        // MockURLSession을 통해 테스트
        sut.getItemList(pageNumber: 1, itemPerPage: 1) { result in
            switch result {
            case .success(let data):
                guard let test = JSONDecoder.decodeData(data: data, to: ProductList.self) else {
                    XCTFail("Decode Error")
                    return
                }
                XCTAssertEqual(test.pageNumber, test.pageNumber)
                XCTAssertEqual(test.lastPage, test.pageNumber)
            case .failure(_):
                XCTFail("getItemList failure")
                return
            }
        }
    }
    
    func test_getItemList_failure() {
        // MockSession이 강제로 실패하도록 설정
        sut = NetworkManager(session: MockURLSession(isRequestSuccess: false))
        
        // MockSession의 실패 응답의 httpStatus가 402로 설정되었으므로 반환되는 에러는 statusCodeError
        sut.getItemList(pageNumber: 1, itemPerPage: 1) { result in
            switch result {
            case .success(_):
                XCTFail("result is success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.clientError)
            }
        }
    }
}
