import XCTest
@testable import OpenMarket

class APIManagerTests: XCTestCase {
    var sutAPIManager: APIManager!
    
    override func setUp() {
        sutAPIManager = APIManager()
    }

    func test_APIHealth가_정상적으로_받아지는지() {
        sutAPIManager.checkAPIHealth()
        let result = sutAPIManager.apiHealth!
        XCTAssertEqual(result, "\"OK\"")
    }

    func test_아이디가_13인_상품의_상세조회_정상작동_확인() {
        sutAPIManager.checkProductDetail(from: 13)
        let result = sutAPIManager.product?.name
        XCTAssertEqual(result, "팥빙수")
    }

}
