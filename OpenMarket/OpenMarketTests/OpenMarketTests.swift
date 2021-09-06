//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 박태현 on 2021/09/01.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    let sut: NetworkManager! = nil

    func testModel_ParsingItemWithMockData_success() {
        // give
        let testTarget = "MockItem"

        guard let json = try? CustomJSONDecoder.fetchFromAssets(assetName: testTarget) else {
            return XCTFail("json 파일을 찾을 수 없습니다.")
        }
        // when
        guard let decodedData = try? CustomJSONDecoder().decode(Item.self, from: json.data) else {
            return XCTFail("decoding에 실패했습니다.")
        }
        let result = decodedData.title
        let expectResult = "MacBook Pro"
        // then
        XCTAssertEqual(result, expectResult)
    }

    func testModel_ParsingItemsWithMockData_success() {
        // give
        let testTarget = "MockItems"

        guard let json = try? CustomJSONDecoder.fetchFromAssets(assetName: testTarget) else {
            return XCTFail("json 파일을 찾을 수 없습니다.")
        }
        // when
        guard let decodedData = try? CustomJSONDecoder().decode(Items.self, from: json.data) else {
            return XCTFail("decoding에 실패했습니다.")
        }
        let result = decodedData.page
        let expectResult = 1
        // then
        XCTAssertEqual(result, expectResult)
    }

    func testNetworkManager_commuteFromMockNetwork_successs() {
        // give
        let id = 1
        let mockData = "MockItem"

        guard let json = try? CustomJSONDecoder.fetchFromAssets(assetName: mockData) else {
            return XCTFail("json 파일을 찾을 수 없습니다.")
        }
        guard let expectData = try? CustomJSONDecoder().decode(Item.self, from: json.data) else {
            return XCTFail("decoding에 실패했습니다.")
        }
        let sut = NetworkManager(session: MockURLSession(isRequestSuccess: true, mockData: mockData))
        // when
        sut.commuteWithAPI(with: GetItemAPI(id: id)) { result in
            // then
            switch result {
            case .success(let item):
                guard let patchData = try? CustomJSONDecoder().decode(Item.self, from: item) else {
                    return XCTFail("decoding에 실패했습니다.")
                }
                XCTAssertEqual(patchData.title, expectData.title)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testNetworkManager_commuteFromMockNetwork_failure() {
        // give
        let id = 1
        let mockData = "MockItem"

        let sut = NetworkManager(session: MockURLSession(isRequestSuccess: false, mockData: mockData))
        // when
        sut.commuteWithAPI(with: GetItemAPI(id: id)) { result in
            // then
            guard case .failure(let error) = result else {
                return XCTFail("false response이므로 성공하면 안됩니다.")
            }
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidResponse)
        }
    }

    func testNetworkManager_commuteFromNetwork_GETItems_Success() {
        // give
        let page = 1
        let sut = NetworkManager()
        // when
        sut.commuteWithAPI(with: GetItemsAPI(page: page)) { result in
            // then
            guard case .success(let items) = result else {
                return XCTFail("네트워크 통신에 실패했습니다")
            }
            guard let decodedData = try? CustomJSONDecoder().decode(Items.self, from: items) else {
                return XCTFail("받아온 데이터의 디코딩에 실패했습니다.")
            }
            XCTAssertEqual(decodedData.page, page)
        }
    }

    func testNetworkManager_commuteFromNetwork_GETItem_Success() {
        // give
        let id = 53
        let sut = NetworkManager()
        // when
        sut.commuteWithAPI(with: GetItemAPI(id: id)) { result in
            // then
            guard case .success(let item) = result else {
                return XCTFail("네트워크 통신에 실패했습니다")
            }
            guard let decodedData = try? CustomJSONDecoder().decode(Item.self, from: item) else {
                return XCTFail("받아온 데이터의 디코딩에 실패했습니다.")
            }
            XCTAssertEqual(decodedData.id, id)
        }
    }
}
