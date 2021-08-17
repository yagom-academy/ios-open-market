//
//  URLSessionTests.swift
//  OpenMarketTests
//
//  Created by Kim Do hyung on 2021/08/16.
//

import XCTest
@testable import OpenMarket

class URLSessionTests: XCTestCase {
    
    var sut: NetworkManager!
    var url: URL!
    var parsingManager = ParsingManager()
    var expectation: XCTestExpectation!
    var dummyPostItem: PostItem!
    var dummyPatchItem: PatchItem!
    var dummyDeleteItem: DeleteItem!
    
    var expectResultTitle: String!
    var expectResultDescription: String!
    var expectResultPrice: Int!
    var expectResultCurrency: String!
    var expectResultStock: Int!
    var expectResultImages: [Media]!
    var expectResultPassword: String!
    
    override func setUpWithError() throws {
        expectation = XCTestExpectation()
        url = URL(string: "https://test.com/")!
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        sut = NetworkManager.init(session: urlSession)
        
        expectResultTitle = "MacBook Pro"
        expectResultDescription = "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다."
        expectResultPrice = 1690000
        expectResultCurrency = "KRW"
        expectResultStock = 1000000000000
        expectResultImages = [
            Photo(withImage: UIImage(named: "MackBookImage_0")!)!,
            Photo(withImage: UIImage(named: "MackBookImage_1")!)!
        ]
        expectResultPassword = "asdf"
        
        dummyPostItem = PostItem(title: expectResultTitle,
                                 descriptions: expectResultDescription,
                                 price: expectResultPrice,
                                 currency: expectResultCurrency, stock: expectResultStock, discountedPrice: nil,
                                 mediaFile: expectResultImages, password: expectResultPassword)
        
        dummyPatchItem = PatchItem(title: nil, descriptions: nil, price: nil,
                                   currency: nil, stock: nil, discountedPrice: nil,
                                   mediaFile: nil, password: expectResultPassword)
        
        dummyDeleteItem = DeleteItem(password: expectResultPassword)
    }
    
    func test_request_get() {
        //given
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = NSDataAsset(name: "Item")!.data
            
            return (response, data)
        }
        //when
        sut.request(requsetType: .get, url: "https://test.com/") { [self] (result) in
            //then
            switch result {
            case .success(let data):
                let item = parsingManager.decodingData(data: data, model: Product.self)
                XCTAssertEqual(item!.title, expectResultTitle)
                XCTAssertEqual(item!.descriptions, expectResultDescription)
                XCTAssertEqual(item!.price, expectResultPrice)
                XCTAssertEqual(item!.currency, expectResultCurrency)
                XCTAssertEqual(item!.stock, expectResultStock)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_request_post() {
        //given
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = NSDataAsset(name: "Item")!.data
            
            return (response, data)
        }
        //when
        sut.request(requsetType: .post, url: "https://test.com/", model: dummyPostItem) { [self] (result) in
            //then
            switch result {
            case .success(let data):
                let item = parsingManager.decodingData(data: data, model: Product.self)
                XCTAssertEqual(item!.title, expectResultTitle)
                XCTAssertEqual(item!.descriptions, expectResultDescription)
                XCTAssertEqual(item!.price, expectResultPrice)
                XCTAssertEqual(item!.currency, expectResultCurrency)
                XCTAssertEqual(item!.stock, expectResultStock)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_request_patch() {
        //given
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = NSDataAsset(name: "Item")!.data
            
            return (response, data)
        }
        //when
        sut.request(requsetType: .patch, url: "https://test.com/", model: dummyPatchItem) { [self] (result) in
            //then
            switch result {
            case .success(let data):
                let item = parsingManager.decodingData(data: data, model: Product.self)
                XCTAssertEqual(item!.title, expectResultTitle)
                XCTAssertEqual(item!.descriptions, expectResultDescription)
                XCTAssertEqual(item!.price, expectResultPrice)
                XCTAssertEqual(item!.currency, expectResultCurrency)
                XCTAssertEqual(item!.stock, expectResultStock)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_request_delete() {
        //given
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = NSDataAsset(name: "Item")!.data
            
            return (response, data)
        }
        //when
        sut.request(requsetType: .delete, url: "https://test.com/", model: dummyDeleteItem) { [self] (result) in
            //then
            switch result {
            case .success(let data):
                let item = parsingManager.decodingData(data: data, model: Product.self)
                XCTAssertEqual(item!.title, expectResultTitle)
                XCTAssertEqual(item!.descriptions, expectResultDescription)
                XCTAssertEqual(item!.price, expectResultPrice)
                XCTAssertEqual(item!.currency, expectResultCurrency)
                XCTAssertEqual(item!.stock, expectResultStock)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_response가404일때_get을_요청하면_error가뜬다() {
        //given
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 404, httpVersion: nil, headerFields: nil)!
            let data = NSDataAsset(name: "Item")!.data
            
            return (response, data)
        }
        //when
        var expectResult = false
        sut.request(requsetType: .get, url: "https://test.com/") { [self] (result) in
            //then
            switch result {
            case .success:
                XCTFail("통과 되었음 에러!!")
            case .failure:
                expectResult = true
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(expectResult)
    }
}


//
//    func test_requst_post() {
//        let url: URL = URL(string: "https://test.com/")!
//
//        MockURLProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
//            let data = NSDataAsset(name: "Item")!.data
//
//            return (response, data)
//        }
//
//        let encodedData = parsingManager.encodingModel(model: dummyPostItem)
//
//        sut.request(requsetType: .post, url: "https://test.com/", body: encodedData) { [self] (result) in
//            switch result {
//            case .success(let data):
//                let item = parsingManager.decodingData(data: data, model: Product.self)
//                XCTAssertEqual(item!.title, "MacBook Pro")
//                XCTAssertEqual(item!.descriptions, "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.")
//                XCTAssertEqual(item!.price, 1690000)
//                XCTAssertEqual(item!.currency, "KRW")
//                XCTAssertEqual(item!.stock, 1000000000000)
//            case .failure(let error):
//                XCTFail(error.localizedDescription)
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 10)
//    }
//
//    func test_requst_patch() {
//        let url: URL = URL(string: "https://test.com/")!
//
//        MockURLProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
//            let data = NSDataAsset(name: "Item")!.data
//
//            return (response, data)
//        }
//
//        let encodedData = parsingManager.encodingModel(model: dummyPatchItem)
//
//        sut.request(requsetType: .patch, url: "https://test.com/", body: encodedData) { [self] (result) in
//            switch result {
//            case .success(let data):
//                let item = parsingManager.decodingData(data: data, model: Product.self)
//                XCTAssertEqual(item!.title, "MacBook Pro")
//                XCTAssertEqual(item!.descriptions, "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.")
//                XCTAssertEqual(item!.price, 1690000)
//                XCTAssertEqual(item!.currency, "KRW")
//                XCTAssertEqual(item!.stock, 1000000000000)
//            case .failure(let error):
//                XCTFail(error.localizedDescription)
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 10)
//    }
//
//    func test_failResponse() {
//        let url: URL = URL(string: "https://test.com/")!
//
//        MockURLProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
//            let data = NSDataAsset(name: "Item")!.data
//
//            return (response, data)
//        }
//
//        sut.requestGet(url: "https://test.com/") { [self] (result) in
//            switch result {
//            case .success(let data):
//                let _ = parsingManager.decodingData(data: data, model: Product.self)
//                XCTFail("통과 되었음 에러!!")
//            case .failure(let error):
//                print("test")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 10)
//    }
//
//
//    //data nil로 설정했는데 받아올때 0바이트로 받아짐 -ㅅ-
//    func test_invaildData() {
//        let url: URL = URL(string: "https://test.com/")!
//
//        MockURLProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
//
//            return (response, nil)
//        }
//
//        var result = false
//
//        sut.requestGet(url: "https://test.com/") { [self] (response) in
//            switch response {
//            case .success(let data):
//                let item = parsingManager.decodingData(data: data, model: Product.self)
//                XCTFail("통과 되었음 에러!!")
//            case .failure(let error):
//                result = true
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 10)
//        XCTAssertTrue(result)
//    }

