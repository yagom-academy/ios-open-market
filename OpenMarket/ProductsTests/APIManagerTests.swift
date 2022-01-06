import XCTest

class APIManagerTests: XCTestCase {
    var sut: APIManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = APIManager()
    }
    
    func test_healthChecker가_API통신성공시_data값이_OK인지() {
        sut?.requestHealthChecker()
        let result = sut?.healthChecker
        
        XCTAssertEqual(result, "\"OK\"")
    }
    
    func test_productInformation의_id가_13일때_name의_값이_팥빙수인지() {
        sut.requestProductInformation(productID: 13)
        let result = sut.product?.name
        
        XCTAssertEqual(result, "팥빙수")
    }
    
    func test_productList의_limit의_값이_20인지() {
        sut.requestProductList()
        let result = sut.productList?.limit
        
        XCTAssertEqual(result, 20)
    }
}
