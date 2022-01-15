import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    var sut: ProductService!

    override func setUpWithError() throws {
        sut = ProductService()
        let vendorIdentification = "cd706a3e-66db-11ec-9626-796401f2341a"
        UserDefaultUtility().setVendorIdentification(vendorIdentification)
    }

    func test_checkNetworkConnection() {
        let expectaion = XCTestExpectation(description: "")

        sut.checkNetworkConnection(session: HTTPUtility.defaultSession) { result in
            switch result {
            case .success(let networkHealth):
                XCTAssertEqual(networkHealth, "OK")
            case .failure:
                XCTFail("통신 실패")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }

    func test_retrieveProduct() {
        let expectaion = XCTestExpectation(description: "")

        sut.retrieveProduct(
            productIdentification: 108,
            session: HTTPUtility.defaultSession
        ) { result in
            switch result {
            case .success(let product):
                XCTAssertEqual(product.name, "Yeha")
            case .failure:
                XCTFail("상품 조회 실패")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }

    func test_retrieveSecretOfProduct() {
        let expectaion = XCTestExpectation(description: "")
        let secret = SecretOfProductRequest(secret: "password")

        sut.retrieveSecretOfProduct(
            identification: 107,
            body: secret,
            session: HTTPUtility.defaultSession
        ) { result in
            switch result {
            case .success(let secret):
                XCTAssertNotNil(secret)
            case .failure:
                XCTFail("상품 secret 조회 실패")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }

    func test_deleteProduct() {
        let expectaion = XCTestExpectation(description: "")

        sut.deleteProduct(
            identification: 109,
            productSecret: "4df1f4fd-7011-11ec-abfa-7729db260f07",
            session: HTTPUtility.defaultSession
        ) { result in
            switch result {
            case .success(let product):
                XCTAssertNotNil(product)
            case .failure:
                XCTFail("상품 삭제 실패")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }

    func test_modifyProduct() {
        let expectaion = XCTestExpectation(description: "")
        let productToModify = ProductModificationRequest(
            price: 10000,
            secret: "password"
            )

        sut.modifyProduct(
            identification: 201,
            body: productToModify,
            session: HTTPUtility.defaultSession
        ) { result in
            switch result {
            case .success(let product):
                XCTAssertEqual(product.price, 10000)
            case .failure:
                XCTFail("상품 수정 실패")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }

    func test_registerProduct() {
        let expectaion = XCTestExpectation(description: "")
        let param = RegisterProductRequest(
            name: "MacBook M1 Pro",
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
            case .success(let product):
                XCTAssertNotNil(product)
            case .failure:
                XCTFail("상품 등록 실패")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }
}
