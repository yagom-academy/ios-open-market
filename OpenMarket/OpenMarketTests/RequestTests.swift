//
//  RequestTests.swift
//  OpenMarketTests
//
//  Created by NAMU on 2022/07/12.
//

import XCTest
@testable import OpenMarket

class RequestTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func test_APIRequest를_받아와서_디코딩이_잘되는지() {
        struct RequestData: APIRequest {}
        let requestData = RequestData()

        requestData.requestData(pageNumber: 1, itemPerPage: 10)
        { (result: Result<ProductsList, Error>) in
                switch result {
                case .success(let data):
                    print(data.pages[0].name)
                case .failure(let error):
                    print(error)
                }
        }
    }
}
