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
        let network = Network()
        let jsonEncoder = JSONEncoder()
        let usecase = ProductRegisterUseCase(network: network, jsonEncoder: jsonEncoder)
        let parameter = RegistrationParameter(name: "북맥",
                                              descriptions: "이것은 맥북이다",
                                              price: 100000,
                                              currency: Currency.KRW,
                                              discountedPrice: 1000,
                                              stock: 10,
                                              secret: Secret.registerSecret)
        var imageArray: [UIImage] = []
        guard let swiftImage = UIImage(systemName: "swift") else { return }
        imageArray.append(swiftImage)
        let encodedData = usecase.registerProduct(registrationParameter: parameter,
                                                   images: imageArray) {
            promise.fulfill()
        } errorHandler: { error in
            XCTFail()
        }
        wait(for: [promise], timeout: 10)
        // then

        // when
    }
}
