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
            NSDataAsset(name: "image0")!.data,
            NSDataAsset(name: "image1")!.data
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
        
    }
    
    func test_request_post() {
        
    }
    
    func test_request_patch() {
        
    }
    
    func test_request_delete() {
        
    }
    
    func test_request_실행중_client_error_발생시_sessionError를_completionHandler에_전달한다() {
        
    }
    
    func test_원하는_response가_오지않은_경우_wrongResponse를_completionHandler에_전달한다() {
        
    }
    
    func test_received_data가_nil인경우_invalidData를_completionHandler에_전달한다() {
        
    }
    
    func test_received_data를_json으로_decode할_수_없는_경우_invalidData를_completionHandler에_전달한다() {
        
    }
}
