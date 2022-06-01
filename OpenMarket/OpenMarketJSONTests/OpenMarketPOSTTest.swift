//
//  OpenMarketPOSTTest.swift
//  OpenMarketJSONTests
//
//  Created by 우롱차, Donnie on 2022/05/31.
//

import XCTest
@testable import OpenMarket

class OpenMarketPOSTTest: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func test_encodingTest() {
        // given
        let promise = expectation(description: "timeout 테스트")
        let name = "북맥북맥"
        let descriptions = "이것은 맥북이다"
        let price: Double = 100000
        let currency = Currency.KRW
        let discountedPrice: Double = 1000
        let stock = 10
        let secret = Secret.registerSecret
        let network = Network()
        let jsonEncoder = JSONEncoder()
        let jsonDecoder = JSONDecoder()
        let usecase = ProductRegisterUseCase(network: network, jsonEncoder: jsonEncoder)
        let parameter = RegistrationParameter(name: name,
                                              descriptions: descriptions,
                                              price: price,
                                              currency: currency,
                                              discountedPrice: discountedPrice,
                                              stock: stock,
                                              secret: secret)
        var imageArray: [UIImage] = []
        guard let swiftImage = UIImage(systemName: "swift") else { return }
        imageArray.append(swiftImage)
        usecase.registerProduct(registrationParameter: parameter,
                                                  images: imageArray) { data, _ in
            guard let productDetail = try? jsonDecoder.decode(ProductDetail.self, from: data) else {
                XCTFail("디코딩 실패")
                return
            }
            //객체로 비교하지 않은 이유: id값이 통신할때 랜덤이라서 비교하지않음.
            XCTAssertEqual(productDetail.name, name)
            XCTAssertEqual(productDetail.description, descriptions)
            XCTAssertEqual(productDetail.price, price)
            XCTAssertEqual(productDetail.currency.rawValue, currency.rawValue)
            XCTAssertEqual(productDetail.discountedPrice, discountedPrice)
            XCTAssertEqual(productDetail.stock, stock)
            
            promise.fulfill()
        } errorHandler: { error in
            XCTFail()
        }
        wait(for: [promise], timeout: 20)
        // then
        
        // when
    }
    
    func test_encodingTest2() {
        // given
        let promise = expectation(description: "timeout 테스트")
        let name = "북맥북맥"
        let descriptions = "이것은 맥북이다"
        let price: Double = 100000
        let currency = Currency.KRW
        let discountedPrice: Double = 1000
        let stock = 10
        let secret = Secret.registerSecret
        let data = """
                    {
                      "id": 4,
                      "vendor_id": 3,
                      "name": "\(name)",
                      "description": "\(descriptions)",
                      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/87aa7c8966df11ecad1df993f20d4a2a.jpg",
                      "currency": "\(currency)",
                      "price": \(price),
                      "bargain_price": \(price),
                      "discounted_price": \(discountedPrice),
                      "stock": \(stock),
                      "created_at": "2021-12-27 15:37:58.072",
                      "issued_at": "2021-12-27 15:37:58.072",
                      "images": [
                        {
                          "id": 4,
                          "url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/origin/87aa7c8966df11ecad1df993f20d4a2a.jpg",
                          "thumbnail_url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/87aa7c8966df11ecad1df993f20d4a2a.jpg",
                          "succeed": true,
                          "issued_at": "2021-12-27 15:37:58.427"
                        }
                      ],
                      "vendors": {
                        "name": "Vendor2",
                        "id": 3,
                        "created_at": "2021-12-27 00:00:00.000",
                        "issued_at": "2021-12-27 00:00:00.000"
                      }
                    }
                    """.data(using: .utf8)
        
        let parameter = RegistrationParameter(name: name,
                                              descriptions: descriptions,
                                              price: price,
                                              currency: currency,
                                              discountedPrice: discountedPrice,
                                              stock: stock,
                                              secret: secret)
        
        var imageArray: [UIImage] = []
        guard let swiftImage = UIImage(systemName: "swift") else { return }
        imageArray.append(swiftImage)
        
        guard let url = OpenMarketApi.productRegister(registrationParameter: parameter, images: imageArray).url else { return }
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: data, response: response, error: nil)
        let stubUrlSession: URLSessionProtocol = StubURLSession(dummy: dummy)
        let network = Network(session: stubUrlSession)
        let jsonEncoder = JSONEncoder()
        let jsonDecoder = JSONDecoder()
        let usecase = ProductRegisterUseCase(network: network, jsonEncoder: jsonEncoder)
        
        usecase.registerProduct(registrationParameter: parameter,
                                                  images: imageArray) { data, _ in
            guard let productDetail = try? jsonDecoder.decode(ProductDetail.self, from: data) else {
                XCTFail("디코딩 실패")
                return
            }
            XCTAssertEqual(productDetail.name, name)
            XCTAssertEqual(productDetail.description, descriptions)
            XCTAssertEqual(productDetail.price, price)
            XCTAssertEqual(productDetail.currency.rawValue, currency.rawValue)
            XCTAssertEqual(productDetail.discountedPrice, discountedPrice)
            XCTAssertEqual(productDetail.stock, stock)
            promise.fulfill()
        } errorHandler: { error in
            XCTFail()
        }
        wait(for: [promise], timeout: 20)
        // then
        
        // when
    }
}
