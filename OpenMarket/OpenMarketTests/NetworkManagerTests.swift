//
//  NetworkManagerTests.swift
//  OpenMarketTests
//
//  Created by Gundy, Wonbi on 2022/11/16.
//

import XCTest
@testable import OpenMarket

class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        networkManager = .init()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        networkManager = nil
    }
    
    func test_dummyData를통해_productList를_리퀘스트했을때_fetchData가_정상작동하는지() {
        // given
        let productListRequest: ProductListRequest = .init(pageNo: 1, itemsPerPage: 20)
        guard let url = productListRequest.urlComponents else { return }
        let data: Data? = DataLoader.data(fileName: "products")
        guard let data = data else { return }
        let mockURLSession: MockURLSession = {
            let response: HTTPURLResponse? = HTTPURLResponse(url: url,
                                                            statusCode: 200,
                                                            httpVersion: nil,
                                                            headerFields: nil)
            let dummyData: DummyData = .init(data: data,
                                             response: response,
                                             error: nil)
            return MockURLSession(dummy: dummyData)
        }()
        networkManager.session = mockURLSession
        
        // when
        var result: ProductList?
        networkManager.fetchData(for: url, dataType: ProductList.self) { response in
            if case let .success(productList) = response {
                result = productList
            }
        }
        let expectation: ProductList? = JSONDecoder.decode(ProductList.self, from: data)
        
        // then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.pages.count, expectation?.pages.count)
    }
}
