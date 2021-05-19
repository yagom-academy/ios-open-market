//
//  SessionManagerTests.swift
//  OpenMarketTests
//
//  Created by 천수현 on 2021/05/13.
//

import XCTest
@testable import OpenMarket

class SessionManagerHTTPTests: XCTestCase {
    var sut: SessionManager!
    var dummyPostingItem: PostingItem!
    var dummyPatchingItem: PatchingItem!
    var dummyDeletingItem: DeletingItem!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        
        let urlSession = URLSession(configuration: configuration)
        
        sut = SessionManager(requestBodyEncoder: MockRequestBodyEncoder(), session: urlSession)
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
        dummyPostingItem = nil
        dummyPatchingItem = nil
    }
    
    func test_request_get() {
        let expectation = XCTestExpectation()
        let url: URL = URL(string: "https://yagom.net/")!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = NSDataAsset(name: "Item")!.data

            return (response, data, nil)
        }

        sut.request(method: .get, path: .item(id: 1)) { (result: Result<Item, OpenMarketError>) in
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
        let url: URL = URL(string: "https://yagom.net/")!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = NSDataAsset(name: "Item")!.data

            return (response, data, nil)
        }

        sut.request(method: .post, path: .item(id: nil), data: dummyPostingItem) { (result: Result<Item, OpenMarketError>) in
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
        func test_request_post() {
            let expectation = XCTestExpectation()
            let url: URL = URL(string: "https://yagom.net/")!

            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
                let data = NSDataAsset(name: "Item")!.data

                return (response, data, nil)
            }

            sut.request(method: .patch, path: .item(id: nil), data: dummyPatchingItem) { (result: Result<Item, OpenMarketError>) in
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
    }
    
    func test_request_delete() {
        func test_request_post() {
            let expectation = XCTestExpectation()
            let url: URL = URL(string: "https://yagom.net/")!

            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
                let data = NSDataAsset(name: "Item")!.data

                return (response, data, nil)
            }

            sut.request(method: .delete, path: .item(id: nil), data: dummyDeletingItem) { (result: Result<Item, OpenMarketError>) in
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
    }
    
    func test_request_실행중_client_error_발생시_sessionError를_completionHandler에_전달한다() {
        let expectation = XCTestExpectation()
        
        MockURLProtocol.requestHandler = { request in
            let error = OpenMarketError.didNotReceivedData as Error
            
            return (nil, nil, error)
        }
        
        sut.request(method: .get, path: .item(id: 1)) { (result: Result<Item, OpenMarketError>) in
            switch result {
            case .success:
                XCTFail("success가 전달됨")
            case .failure(let error):
                if error != .sessionError {
                    XCTFail("sessionError가 아닌 \(error)가 전달됨")
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_원하는_response가_오지않은_경우_wrongResponse를_completionHandler에_전달한다() {
        let expectation = XCTestExpectation()

        MockURLProtocol.requestHandler = { request in
            let url = URL(string: "https://camp-open-market-2.herokuapp.com/")!
            let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
            let data = NSDataAsset(name: "Item")!.data
            
            return (response, data, nil)
        }
        
        sut.request(method: .get, path: .item(id: 1)) { (result: Result<Item, OpenMarketError>) in
            switch result {
            case .success:
                XCTFail("success가 전달됨")
            case .failure(let error):
                if error != .wrongResponse {
                    XCTFail("wrongResponse가 아닌 \(error)가 전달됨")
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_received_data가_nil인경우_invalidData를_completionHandler에_전달한다() {
        let expectation = XCTestExpectation()

        MockURLProtocol.requestHandler = { request in
            let url = URL(string: "https://camp-open-market-2.herokuapp.com/")!
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response, nil, nil)
        }
        
        sut.request(method: .get, path: .item(id: 1)) { (result: Result<Item, OpenMarketError>) in
            switch result {
            case .success:
                XCTFail("success가 전달됨")
            case .failure(let error):
                if error != .invalidData {
                    XCTFail("invalidData가 아닌 \(error)가 전달됨")
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_received_data를_json으로_decode할_수_없는_경우_invalidData를_completionHandler에_전달한다() {
        let expectation = XCTestExpectation()

        MockURLProtocol.requestHandler = { request in
            let url = URL(string: "https://camp-open-market-2.herokuapp.com/")!
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = UIImage(named: "image0")!.pngData()!
            return (response, data, nil)
        }
        
        sut.request(method: .get, path: .item(id: 1)) { (result: Result<Item, OpenMarketError>) in
            switch result {
            case .success:
                XCTFail("success가 전달됨")
            case .failure(let error):
                if error != .invalidData {
                    XCTFail("invalidData가 아닌 \(error)가 전달됨")
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
}
