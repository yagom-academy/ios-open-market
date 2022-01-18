import XCTest
@testable import OpenMarket

class APIServiceTests: XCTestCase {
    var sut: APIService!
    
    override func setUpWithError() throws {
        sut = APIService(session: MockURLSession())
    }
    
    func test_retrieveProductData호출시_반환되는_상품리스트_데이터의_첫_상품명이_팥빙수인지() {
        let file = Bundle.main.path(forResource: "products", ofType: "json")
        let data = try! String(contentsOfFile: file!).data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let product = try! decoder.decode(ProductList.self, from: data)
        
        sut.retrieveProductList(pageNo: 0, itemsPerPage: 10) { (result: Result<ProductList, APIError>) in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.pages.first?.name, product.pages.first?.name)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func test_retrieveProductData호출시_연결에_실패하는_경우_에러를_반환하는지() {
        sut = APIService(session: MockURLSession(isSuccess: false))
        
        sut.retrieveProductList(pageNo: 0, itemsPerPage: 10) { (result: Result<ProductList, APIError>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.errorDesciption, "Request가 유효하지 않습니다")
            }
        }
    }
}
