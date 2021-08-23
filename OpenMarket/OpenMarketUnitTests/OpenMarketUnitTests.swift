//
//  OpenMarketUnitTests.swift
//  OpenMarketUnitTests
//
//  Created by yun on 2021/08/17.
//

import XCTest
@testable import OpenMarket

class OpenMarketUnitTests: XCTestCase {
    var sut: [ItemBundle] = []
    var decoder: ParsingManager = ParsingManager()
    var mockSesssion: URLSessionProtocol = MockURLSession()
    var manager: NetworkingManager = NetworkingManager(session: MockURLSession(), parsingManager: ParsingManager(), baseURL: "https://camp-open-market-2.herokuapp.com")
    
    func test_success_JSON파일의정보와_디코딩된인스턴스정보가같다() {
        //given
        let path = Bundle(for: type(of: self)).path(forResource: "Item", ofType: "json")
        let jsonFile = try? String(contentsOfFile: path!).data(using: .utf8)
        let id = 1, title = "MacBook Pro", descriptions = "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.", price = 1690000, currency = "KRW", stock = 1000000000000, thumbnails = [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
        ], images = [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
        ], registrationDate = Date(timeIntervalSince1970: 1611523563.719116)
        //when
        let result = decoder.parse(jsonFile!, to: Item.self)
        guard case .success(let instance) = result else {
            XCTAssert(false)
            return
        }
        //then
        if instance.id == id,
           instance.title == title,
           instance.accessDescriptions == descriptions,
           instance.price == price,
           instance.currency == currency,
           instance.accessImages == images,
           instance.registrationDate == registrationDate,
           instance.stock == stock,
           instance.thumbnails == thumbnails
        {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }
    
    func test_failure_JSON파일과모델타입이일치하지않으면_parse메서드실패한다() {
        //given
        let path = Bundle(for: type(of: self)).path(forResource: "Items", ofType: "json")
        let jsonFile = try? String(contentsOfFile: path!).data(using: .utf8)
        //when
        let result = decoder.parse(jsonFile!, to: Item.self)
        //then
        switch result {
        case .success(_):
            XCTAssert(false)
        case .failure(_):
            XCTAssert(true)
        }
    }
    
    func test_success_API를담은URLRequest를매개변수로주면_request메서드성공한다() {
        //given
        let request = URLRequest(url: URL(string: manager.baseURL + "/items/1")!)
        var isSuccess = false
        //when
        manager.request(bundle: request) { result in
            guard case .success(_) = result else {
                return
            }
            isSuccess = true
        }
        //then
        XCTAssert(isSuccess)
    }
    
    func test_success_잘못된URLRequest를매개변수로주면_request메서드실패한다() {
        //given
        let request = URLRequest(url: URL(string: manager.baseURL + "/item/1")!)
        var isSuccess = false
        //when
        manager.request(bundle: request) { result in
            guard case .failure(_) = result else {
                return
            }
            isSuccess = true
        }
        //then
        XCTAssert(isSuccess)
    }
}
