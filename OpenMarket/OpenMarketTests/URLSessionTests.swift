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
    var expectation: XCTestExpectation!
    var parsingManager: ParsingManager = ParsingManager()
    var dummyPostItem: PostItem!
    var dummyPatchItem: PatchItem!
    var dummyDeleteItem: DeleteItem!
    
    override func setUpWithError() throws {
        expectation = XCTestExpectation()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        sut = NetworkManager.init(session: urlSession)
        
        let title = "MacBook Pro"
        let descriptions = "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다."
        let price = 1690000
        let currency = "KRW"
        let stock = 1000000000000
        let images: [Data] = [
            UIImage(named: "MackBookImage_0")!.jpegData(compressionQuality: 1)!,
            UIImage(named: "MackBookImage_1")!.jpegData(compressionQuality: 1)!
        ]
        let password = "asdf"
        
        dummyPostItem = PostItem(title: title,
                                 descriptions: descriptions,
                                 price: price,
                                 currency: currency, stock: stock, discountedPrice: nil,
                                 images: images, password: password)
        
        dummyPatchItem = PatchItem(title: nil, descriptions: nil, price: nil,
                                   currency: nil, stock: nil, discountedPrice: nil,
                                   images: nil, password: password)
        
        dummyDeleteItem = DeleteItem(password: password)
    }
}
