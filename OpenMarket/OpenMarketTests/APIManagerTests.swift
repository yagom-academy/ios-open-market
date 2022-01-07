import XCTest
@testable import OpenMarket

class APIManagerTests: XCTestCase {
    var sutAPIManager: APIManager!
    
    override func setUp() {
        sutAPIManager = APIManager()
    }

    func test_APIHealth가_정상적으로_받아지는지() {
        sutAPIManager.checkAPIHealth { result in
            switch result {
            case .success(let data):
                let apiHealth = String(data: data, encoding: .utf8)!
                XCTAssertEqual(apiHealth, "\"OK\"")
            case .failure(let error):
                XCTAssertThrowsError(error)
            }
        }
    }

    func test_아이디가_13인_상품의_상세조회_정상작동_확인() {
        sutAPIManager.checkProductDetail(id: 13) { result in
            switch result {
            case .success(let data):
                let name = data.name
                XCTAssertEqual(name, "팥빙수")
            case .failure(let error):
                XCTAssertThrowsError(error)
            }
        }
    }

    func test_상품목록의_상품갯수가_20개인지_확인() {
        sutAPIManager.checkProductList(pageNumber: 1, itemsPerPage: 20) { result in
            switch result {
            case .success(let data):
                let count = data.pages.count
                XCTAssertEqual(count, 20)
            case .failure(let error):
                XCTAssertThrowsError(error)
            }
        }
    }

}
