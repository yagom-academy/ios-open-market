//
//import XCTest
//@testable import OpenMarket
//
//class MockOpenMarketTests: XCTestCase {
//    var sut: OpenMarketAPIManager!
//
//    override func setUpWithError() throws {
//        sut = .init(session: MockURLSession())
//    }
//
//    override func tearDownWithError() throws {
//    }
//
//    func testFetchProductListofPageOne() {
//        let expectation = XCTestExpectation()
//        let response = try? JSONDecoder().decode(ProductList.self, from: MockAPI.test.sampleItems.data)
//
//        sut.requestProductList(of: 1) { (result) in
//            switch result {
//            case .success(let productList):
//                XCTAssertEqual(productList.items[3].id, response?.items[3].id)
//                XCTAssertEqual(productList.items[3].currency, response?.items[3].currency)
//                XCTAssertEqual(productList.items[3].price, response?.items[3].price)
//                XCTAssertEqual(productList.items[3].discountedPrice, response?.items[3].discountedPrice)
//                XCTAssertEqual(productList.items[3].registrationDate, response?.items[3].registrationDate)
//            case .failure:
//                XCTFail()
//            }
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func testFetchProductListofPageOneFailure() {
//        sut = .init(session: MockURLSession(makeRequestFail: true))
//        let expectation = XCTestExpectation()
//
//        sut.requestProductList(of: 1) { (result) in
//            switch result {
//            case .success(let product):
//                XCTFail()
//            case .failure(let error):
//                XCTAssertEqual(error.self, .invalidData)
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func testFetchProductofIdEleven() {
//        sut = .init(session: MockURLSession(makeRequestFail: false))
//        let expectationn = XCTestExpectation()
//        let response = try? JSONDecoder().decode(Product.self, from: MockAPI.test.sampleItem.data)
//
//        sut.requestProduct(of: 11) { (result) in
//            switch result {
//            case .success(let product):
//                XCTAssertEqual(product.title, response?.title)
//            case .failure(let error):
//                XCTFail()
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func testRequestProductRegistration() {
//        sut = .init(session: URLSession(configuration: .default))
//        let product = Product.init(id: nil, title: "태태의 연필", descriptions: "비밀번호486", price: 500, currency: "USD", stock: 2, discountedPrice: 50, thumbnails: nil, images: [], registrationDate: nil, password: "486")
//        let expectation = XCTestExpectation()
//
//        sut.requestRegistration(product: product) { result in
//            switch result {
//            case .success(let product):
//                expectation.fulfill()
//                dump(product)
//            case .failure(let error):
//                print(error)
//            }
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//}
