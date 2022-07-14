//
//  JsonTest.swift
//  JsonTest
//
//  Created by BaekGom, Brad on 2022/07/11.
//

import XCTest
@testable import OpenMarket

class JsonTest: XCTestCase {
    var mock: NSDataAsset!
    var jsonDecoder: JSONDecoder!
    
    let mockSession = MockURLSession()
    var sut: JSONParser!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mock = NSDataAsset.init(name: "products")
        jsonDecoder = JSONDecoder()
        sut = .init(session: mockSession)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mock = nil
        jsonDecoder = nil
    }
    
    func test_getPageNo_success() {
        //given
        let realdata = try? jsonDecoder.decode(ProductListResponse.self, from: mock.data)
        //when
        sut.dataTask(by: URLCollection.productListInquery, completion: { (response) in
            switch response {
            case .success(let data):
                guard let testvalue = try? JSONDecoder().decode(ProductListResponse.self, from: data as! Data) else {
                    XCTFail("Decode Error")
                    return
                }
                XCTAssertEqual(testvalue.pageNo, realdata?.pageNo)
            case .failure(_):
                XCTFail("Get Fail")
            }
        })
    }
    
    func test_getPageNo_failure() {
        sut = JSONParser(session: MockURLSession(isRequestSuccess: false))
        
        sut.dataTask(by: URLCollection.productListInquery, completion: { (response) in
            switch response {
            case .success(_):
                XCTFail("result is success")
            case .failure(let error):
                XCTAssertEqual(error, CustomError.statusCodeError)
            }
        })
    }
}
