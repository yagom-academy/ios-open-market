//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by yeha on 2022/01/06.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    var sut: ProductService!

    override func setUpWithError() throws {
        sut = ProductService()
        UserDefaultUtility().setVendorIdentification(identification: "cd706a3e-66db-11ec-9626-796401f2341a")
    }

    func test_checkNetworkConnection() {
        let expectaion = XCTestExpectation(description: "")

        sut.checkNetworkConnection(session: HTTPUtility.defaultSession) { result in
            switch result {
            case .success(let data):
                guard let encodedData = String(data: data, encoding: .utf8) else {
                    return XCTFail("파싱 실패")
                }
                XCTAssertEqual(encodedData, "\"OK\"")
            case .failure:
                XCTFail("통신 실패")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }

    func test_retrieveProduct() {
        let expectaion = XCTestExpectation(description: "")

        sut.retrieveProduct(productIdentification: 108, session: HTTPUtility.defaultSession) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData: Product = try DecodeUtility.decode(data: data)
                    print(decodedData)
                    XCTAssertEqual(decodedData.name, "Yeha")
                } catch {
                    XCTFail("파싱 실패")
                }
            case .failure:
                XCTFail("통신 실패")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }

    func test_retrieveSecretOfProduct() {
        let expectaion = XCTestExpectation(description: "")
        let secret = SecretOfProductRequest(secret: "password")

        sut.retrieveSecretOfProduct(identification: 77, body: secret, session: HTTPUtility.defaultSession) { result in
            switch result {
            case .success(let data):
                guard let encodedData = String(data: data, encoding: .utf8) else {
                    return XCTFail("파싱 실패")
                }
                print(encodedData)
                XCTAssertNotNil(encodedData)
            case .failure:
                XCTFail("통신 실패")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }

    func test_deleteProduct() {
        let expectaion = XCTestExpectation(description: "")

        sut.deleteProduct(
            identification: 77,
            productSecret: "2d658dc7-6eec-11ec-abfa-2316e964ddaa",
            session: HTTPUtility.defaultSession
        ) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData: Product = try DecodeUtility.decode(data: data)
                    print(decodedData)
                } catch {
                    XCTFail("파싱 실패")
                }
            case .failure:
                XCTFail("통신 실패")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }

    func test_modifyProduct() {
        let expectaion = XCTestExpectation(description: "")
        let secret = ProductModificationRequest(secret: "password")

        sut.modifyProduct(
            identification: 90,
            body: secret,
            session: HTTPUtility.defaultSession
        ) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData: Product = try DecodeUtility.decode(data: data)
                    print(decodedData)
                } catch {
                    XCTFail("파싱 실패")
                }
            case .failure:
                XCTFail("통신 실패")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }

    func test_registerProduct() {
        let expectaion = XCTestExpectation(description: "")
        let param = RegisterProductRequest(
            name: "Yeha",
            descriptions: "pasta",
            price: 200,
            currency: .KRW,
            secret: "password")
        var images: [Data] = []
        let imageData = UIImage(named: "robot")!.pngData()!
        images.append(imageData)
        sut.registerProduct(
            parameters: param,
            session: HTTPUtility.defaultSession,
            images: images
        ) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData: Product = try DecodeUtility.decode(data: data)
                    XCTAssertNotNil(decodedData)
                } catch {
                    XCTFail("파싱 실패")
                }
            case .failure:
                XCTFail("통신 실패")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }
}
