//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Hailey, Ryan on 2021/05/11.
//

import XCTest
@testable import OpenMarket

final class OpenMarketTests: XCTestCase {
    
    private var client: NetworkManager!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        client = NetworkManager(urlSession)
    }
    
    override func tearDownWithError() throws {
        MockURLProtocol.loadingHandler = nil
    }
    
    func testGetItems() {
        setTestEnvironment(
            url: OpenMarketURL.viewItemList(1).url,
            networkShouldSuccess: true,
            decodeType: ItemList.self,
            expectationTimeout: 1
        ) { url, decodedData, expectation in
            client.request(ItemList.self, url: url) { result in
                switch result {
                case .success(let responseData):
                    XCTAssertEqual(responseData, decodedData)
                case .failure(let error):
                    XCTFail("\(TestAssets.requestErrorString + error.localizedDescription)")
                }
                expectation.fulfill()
            }
        }
    }

    func testGetItems_failure() {
        setTestEnvironment(
            url: OpenMarketURL.viewItemList(1).url,
            networkShouldSuccess: false,
            decodeType: ItemList.self,
            expectationTimeout: 1
        ) { url, decodedData, expectation in
            client.request(ItemList.self, url: url) { result in
                switch result {
                case .success:
                    XCTFail()
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, APIError.networkFailure(404).localizedDescription)
                }
                expectation.fulfill()
            }
        }
    }

    func testGetItem() {
        setTestEnvironment(
            url: OpenMarketURL.viewItemDetail(1).url,
            networkShouldSuccess: true,
            decodeType: Item.self,
            expectationTimeout: 1
        ) { url, decodedData, expectation in
            client.request(Item.self, url: url) { result in
                switch result {
                case .success(let responseData):
                    XCTAssertEqual(responseData, decodedData)
                case .failure(let error):
                    XCTFail("\(TestAssets.requestErrorString + error.localizedDescription)")
                }
                expectation.fulfill()
            }
        }
    }
    
    func testGetItem_failure() {
        setTestEnvironment(
            url: OpenMarketURL.viewItemDetail(1).url,
            networkShouldSuccess: false,
            decodeType: Item.self,
            expectationTimeout: 1
        ) { url, decodedData, expectation in
            client.request(Item.self, url: url) { result in
                switch result {
                case .success:
                    XCTFail()
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, APIError.networkFailure(404).localizedDescription)
                }
                expectation.fulfill()
            }
        }
    }
    
    func testDeleteItem() {
        setTestEnvironment(
            url: OpenMarketURL.deleteItem(1).url,
            networkShouldSuccess: true,
            httpBody: TestAssets.deleteBody,
            expectationTimeout: 1
        ) { url, deleteBody, expectation in
            client.request(url: url, httpMethod: .delete, body: deleteBody) { result in
                switch result {
                case .success(let responseData):
                    XCTAssertEqual(responseData, TestAssets.mockItem)
                case .failure(let error):
                    XCTFail("\(TestAssets.requestErrorString + error.localizedDescription)")
                }
                expectation.fulfill()
            }
        }
    }
    
    func testDeleteItem_failure() {
        setTestEnvironment(
            url: OpenMarketURL.deleteItem(1).url,
            networkShouldSuccess: false,
            httpBody: TestAssets.deleteBody,
            expectationTimeout: 1
        ) { url, deleteBody, expectation in
            client.request(url: url, httpMethod: .delete, body: deleteBody) { result in
                switch result {
                case .success:
                    XCTFail()
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, APIError.networkFailure(404).localizedDescription)
                }
                expectation.fulfill()
            }
        }
    }
    
    func testPatchItem() {
        setTestEnvironment(
            url: OpenMarketURL.editItem(1).url,
            networkShouldSuccess: true,
            httpBody: TestAssets.editBody,
            expectationTimeout: 1
        ) { url, editBody, expectation in
            client.request(url: url, httpMethod: .patch, body: editBody) { result in
                switch result {
                case .success(let responseData):
                    XCTAssertEqual(responseData.title, editBody.title)
                    XCTAssertEqual(responseData.descriptions, editBody.descriptions)
                case .failure(let error):
                    XCTFail("\(TestAssets.requestErrorString + error.localizedDescription)")
                }
                expectation.fulfill()
            }
        }
    }
    
    func testPatchItem_failure() {
        setTestEnvironment(
            url: OpenMarketURL.editItem(1).url,
            networkShouldSuccess: false,
            httpBody: TestAssets.editBody,
            expectationTimeout: 1
        ) { url, editBody, expectation in
            client.request(url: url, httpMethod: .patch, body: editBody) { result in
                switch result {
                case .success:
                    XCTFail()
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, APIError.networkFailure(404).localizedDescription)
                }
                expectation.fulfill()
            }
        }
    }
    
    func testPostItem() {
        setTestEnvironment(
            url: OpenMarketURL.registerItem.url,
            networkShouldSuccess: true,
            httpBody: TestAssets.postBody,
            expectationTimeout: 1
        ) { url, postBody, expectation in
            client.request(url: url, httpMethod: .post, body: postBody) { result in
                switch result {
                case .success(let responseData):
                    XCTAssertEqual(responseData.title, postBody.title)
                    XCTAssertEqual(responseData.descriptions, postBody.descriptions)
                case .failure(let error):
                    XCTFail("\(TestAssets.requestErrorString + error.localizedDescription)")
                }
                expectation.fulfill()
            }
        }
    }
    
    func testPostItem_failure() {
        setTestEnvironment(
            url: OpenMarketURL.registerItem.url,
            networkShouldSuccess: false,
            httpBody: TestAssets.postBody,
            expectationTimeout: 1
        ) { url, postBody, expectation in
            client.request(url: url, httpMethod: .post, body: postBody) { result in
                switch result {
                case .success:
                    XCTFail()
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, APIError.networkFailure(404).localizedDescription)
                }
                expectation.fulfill()
            }
        }
    }
}

extension OpenMarketTests {
    // MARK: - Private Methods for test
    private func setLoadingHandler(networkShouldSuccess: Bool, _ data: Data) {
        MockURLProtocol.loadingHandler = { request in
            if networkShouldSuccess {
                let response = HTTPURLResponse(
                    url: request.url!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                )!
                
                return (response, data)
            } else {
                let response = HTTPURLResponse(
                    url: request.url!,
                    statusCode: 404,
                    httpVersion: nil,
                    headerFields: nil
                )!
                
                return(response, nil)
            }
        }
    }
    
    private func setTestEnvironment<HTTPBody: Encodable>(
        url: URL?,
        networkShouldSuccess: Bool,
        httpBody: HTTPBody,
        expectationTimeout: Double,
        test: (URL, HTTPBody, XCTestExpectation) -> Void
    ) {
        guard let url = url else { return }
        let mockData: Item = TestAssets.mockItem
        guard let encodedMockData = try? JSONEncoder().encode(mockData) else { return }
        
        setLoadingHandler(networkShouldSuccess: networkShouldSuccess, encodedMockData)
        
        let expectation = XCTestExpectation(description: TestAssets.loadingString)
        test(url, httpBody, expectation)
        wait(for: [expectation], timeout: expectationTimeout)
    }
    
    private func setTestEnvironment<DecodeType: Decodable>(
        url: URL?,
        networkShouldSuccess: Bool,
        decodeType: DecodeType.Type,
        expectationTimeout: Double,
        test: (URL, DecodeType, XCTestExpectation) -> Void
    ) {
        guard let url = url else { return }
        var data: Data?
        
        if decodeType is Item.Type {
            guard let assetData = NSDataAsset(name: TestAssets.item)?.data else { return }
            data = assetData
        } else if decodeType is ItemList.Type {
            guard let assetData = NSDataAsset(name: TestAssets.itemList)?.data else { return }
            data = assetData
        }
        
        guard let data = data else {
            print("적절하지 않은 타입입니다.")
            return
        }
        guard let decodedMockData = try? JSONDecoder().decode(decodeType.self, from: data) else { return }
        
        setLoadingHandler(networkShouldSuccess: networkShouldSuccess, data)
        
        let expectation = XCTestExpectation(description: TestAssets.loadingString)
        test(url, decodedMockData, expectation)
        wait(for: [expectation], timeout: expectationTimeout)
    }
    
    func testNumberFormatInDecimalStyle() {
        let number: Int = 1234567890
        
        guard let formattedNumber: String = number.decimalStyleFormat else { return }
        
        XCTAssertEqual(formattedNumber, "1,234,567,890")
    }
}
