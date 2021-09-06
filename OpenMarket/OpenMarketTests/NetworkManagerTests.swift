//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by 박태현 on 2021/09/01.
//

import XCTest
@testable import OpenMarket

class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager!

    override func setUpWithError() throws {
        sut = NetworkManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_commuteFromMockNetwork_successs() {
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
        sut.commuteWithAPI(API.GetItem(id: id)) { result in
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

    func test_commuteFromMockNetwork_failure() {
        // give
        let id = 1
        let mockData = "MockItem"

        let sut = NetworkManager(session: MockURLSession(isRequestSuccess: false, mockData: mockData))
        // when
        sut.commuteWithAPI(API.GetItem(id: id)) { result in
            // then
            guard case .failure(let error) = result else {
                return XCTFail("false response이므로 성공하면 안됩니다.")
            }
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidResponse)
        }
    }

    func test_commuteFromNetwork_GETItems_Success() {
        // give
        let page = 1
        // when
        sut.commuteWithAPI(API.GetItems(page: page)) { result in
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

    func test_commuteFromNetwork_GETItems_correctNumberOfItems_Success() {
        // give
        let page = 2
        // when
        sut.commuteWithAPI(API.GetItems(page: page)) { result in
            // then
            guard case .success(let items) = result else {
                return XCTFail("네트워크 통신에 실패했습니다")
            }
            guard let decodedData = try? CustomJSONDecoder().decode(Items.self, from: items) else {
                return XCTFail("받아온 데이터의 디코딩에 실패했습니다.")
            }
            XCTAssertEqual(decodedData.items.count, 20)
        }
    }

    func test_commuteFromNetwork_GETItem_Success() {
        // give
        let id = 53
        // when
        sut.commuteWithAPI(API.GetItem(id: id)) { result in
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

    func test_commuteFromNetwork_POSTItem_Success() {
        // give
        let parameters = POSTItem(title: "Macbook Pro", descriptions: "맥북 프로", price: 1000, currency: "WON", stock: 10, discountedPrice: 800, password: "12345").parameter()
        guard let image = Media(imageName: "image1", mimeType: .png, image: #imageLiteral(resourceName: "1f363")) else { return XCTFail("fail") }
        // when
        sut.commuteWithAPI(API.PostItem(parameters: parameters, images: [image])) { result in
            // then
            guard case .success(let item) = result else {
                return XCTFail("네트워크 통신에 실패했습니다")
            }
            guard let decodedData = try? CustomJSONDecoder().decode(Item.self, from: item) else {
                return XCTFail("받아온 데이터의 디코딩에 실패했습니다.")
            }
            XCTAssertEqual(decodedData.title, "Macbook12313 Pro")
        }
    }

    func test_commuteFromNetwork_PATCHItem_Success() {
        // give
        let parameters = PATCHItem(title: "Macbook Pro 21", descriptions: "맥북 프로 신형", price: 10000, currency: "WON", stock: 11, discountedPrice: 8000, password: "12345").parameter()
        guard let image = Media(imageName: "image2", mimeType: .png, image: #imageLiteral(resourceName: "1f363")) else { return }
        // when
        sut.commuteWithAPI(API.PatchItem(id: 53, parameters: parameters, images: [image])) { result in
            // then
            guard case .success(let item) = result else {
                return XCTFail("네트워크 통신에 실패했습니다")
            }
            guard let decodedData = try? CustomJSONDecoder().decode(Item.self, from: item) else {
                return XCTFail("받아온 데이터의 디코딩에 실패했습니다.")
            }
            XCTAssertEqual(decodedData.title, "Macbook Pro")
        }
    }

    func test_commuteFromNetwork_Delete_success() {
        // give
        let password = "12345"
        // when
        sut.commuteWithAPI(API.DeleteItem(id: 53, password: password)) { result in
            // then
            guard case .success(let item) = result else {
                return XCTFail("네트워크 통신에 실패했습니다")
            }
            guard let decodedData = try? CustomJSONDecoder().decode(Item.self, from: item) else {
                return XCTFail("받아온 데이터의 디코딩에 실패했습니다.")
            }
            XCTAssertEqual(decodedData.title, "Macbook Pro 21")
        }
    }
}
