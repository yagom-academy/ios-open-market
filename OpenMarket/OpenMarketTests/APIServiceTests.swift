import XCTest
@testable import OpenMarket

class APIServiceTests: XCTestCase {
    var sut: APIService!
    var urlRequest: URLRequest!
    
    override func setUpWithError() throws {
        sut = APIService(session: MockURLSession())
        urlRequest = URLRequest(url: URL(string: "www.APItestwithoutNetworking.com")!)
    }
    
    func test_retrieveProductData호출시_반환되는_상품리스트_데이터의_첫_상품명이_팥빙수인지() {
        let file = Bundle.main.path(forResource: "products", ofType: "json")
        let data = try! String(contentsOfFile: file!).data(using: .utf8)!
        
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let product = try! decoder.decode(ProductList.self, from: data)
        
        sut.retrieveProductData(request: urlRequest) { (result: Result<ProductList, Error>) in
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
        
        sut.retrieveProductData(request: urlRequest) { (result: Result<ProductList, Error>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "unknown error")
            }
        }
    }
}
