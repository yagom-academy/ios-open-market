//
//  OpenMarketServiceTests.swift
//  OpenMarketTests
//
//  Created by duckbok on 2021/05/26.
//

import XCTest
@testable import OpenMarket

class OpenMarketServiceTests: XCTestCase {
    var sut: OpenMarketService!
    var dummyPostingItem: PostingItem!
    var dummyPatchingItem: PatchingItem!
    var dummyDeletingItem: DeletingItem!

    let title = "MacBook Pro"
    let descriptions = "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다."
    let price = 1690000
    let currency = "KRW"
    let stock = 1000000000000
    let images: [Data] = [
        UIImage(named: "image0")!.pngData()!,
        UIImage(named: "image1")!.pngData()!
    ]
    let password = "1234"

    override func setUpWithError() throws {
        sut = OpenMarketService(sessionManager: MockSessionManager())

        dummyPostingItem = PostingItem(title: title,
                                       descriptions: descriptions,
                                       price: price,
                                       currency: currency, stock: stock, discountedPrice: nil,
                                       images: images, password: password)
        dummyPatchingItem = PatchingItem(title: nil, descriptions: nil, price: nil,
                                         currency: nil, stock: nil, discountedPrice: nil,
                                         images: nil, password: password)
        dummyDeletingItem = DeletingItem(password: password)
    }
    
    override func tearDownWithError() throws {
        sut = nil

        dummyPostingItem = nil
        dummyPatchingItem = nil
        dummyDeletingItem = nil
    }

    func test_request_getItem() {
        let expectation = XCTestExpectation()

        sut.getItem(id: 1) { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(item.title, "MacBook Pro")
                XCTAssertEqual(item.descriptions, "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.")
                XCTAssertEqual(item.price, 1690000)
                XCTAssertEqual(item.currency, "KRW")
                XCTAssertEqual(item.stock, 1000000000000)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }
    
    func test_request_post() {
        let expectation = XCTestExpectation()

        sut.postItem(data: dummyPostingItem) { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(item.title, "MacBook Pro")
                XCTAssertEqual(item.descriptions, "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.")
                XCTAssertEqual(item.price, 1690000)
                XCTAssertEqual(item.currency, "KRW")
                XCTAssertEqual(item.stock, 1000000000000)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }
    
    func test_request_patch() {
        let expectation = XCTestExpectation()

        sut.patchItem(id: 1, data: dummyPatchingItem) { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(item.title, "MacBook Pro")
                XCTAssertEqual(item.descriptions, "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.")
                XCTAssertEqual(item.price, 1690000)
                XCTAssertEqual(item.currency, "KRW")
                XCTAssertEqual(item.stock, 1000000000000)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }
    
    func test_request_delete() {
        let expectation = XCTestExpectation()
        sut.deleteItem(id: 1, data: dummyDeletingItem) { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(item.title, "MacBook Pro")
                XCTAssertEqual(item.descriptions, "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.")
                XCTAssertEqual(item.price, 1690000)
                XCTAssertEqual(item.currency, "KRW")
                XCTAssertEqual(item.stock, 1000000000000)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }
    
    func test_received_data를_json으로_decode할_수_없는_경우_invalidData를_completionHandler에_전달한다() {
        let expectation = XCTestExpectation()
        
        sut.getItem(id: 404) { result in
            switch result {
            case .success:
                XCTFail("success가 전달됨")
            case .failure(let error):
                XCTAssertEqual(error, .invalidData)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
}
