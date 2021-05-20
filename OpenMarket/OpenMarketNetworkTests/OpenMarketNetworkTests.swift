//
//  OpenMarketNetworkTests.swift
//  OpenMarketNetworkTests
//
//  Created by 황인우 on 2021/05/18.
//

import XCTest
@testable import OpenMarket
// internal으로 선언되면 접근 원래는 불가능
// testable을 통해 접근가능
class OpenMarketNetworkTests: XCTestCase {
    
    var sut_openMarketAPIProvider: OpenMarketAPIProvider!
    
    override func setUpWithError() throws {
        setUpProtocolClassesConfiguration()
        try super.setUpWithError()
        
    }
    
    override func tearDownWithError() throws {
        sut_openMarketAPIProvider = nil
        try super.tearDownWithError()
    }
    
    func setUpProtocolClassesConfiguration() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        sut_openMarketAPIProvider = OpenMarketAPIProvider(urlSession: urlSession)
    }
    // MARK: Test Successful Response
    func test_OpenMarketList_SuccessfulResponse() {
        let expectation = XCTestExpectation()
        // given\
        guard let itemListDataAsset = NSDataAsset.init(name: "Items") else { return }
        let requestData = try? JSONDecoder().decode(MarketItemList.self, from: itemListDataAsset.data)
        
        guard let url = SampleOpenMarketAPI.connection.itemListURL else { return }
        
        MockURLProtocol.requestHandler = { request in
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else {
                print("no response")
                return (HTTPURLResponse(), Data())
            }
            
            return (response, SampleOpenMarketAPI.connection.itemListData)
        }
        // when
        sut_openMarketAPIProvider.fetchItemListData { result in
            switch result {
        // then
            case .success(let responseData):
                XCTAssertEqual(requestData, responseData)
            case .failure(let error):
                XCTFail("error was not expected: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

extension MarketItemList: Equatable {
    public static func == (lhs: MarketItemList, rhs: MarketItemList) -> Bool {
        return lhs.items[0].id == rhs.items[0].id
    }
}

extension DetailedItemInformation: Equatable {
    public static func == (lhs: DetailedItemInformation, rhs: DetailedItemInformation) -> Bool {
        return lhs.id == rhs.id
    }
    
}
