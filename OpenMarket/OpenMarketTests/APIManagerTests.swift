import XCTest

class APIManagerTests: XCTestCase {
    var sutAPIManager: APIManager!
    
    override func setUp() {
        sutAPIManager = APIManager(urlSession: MockURLSession())
    }

    func test_APIHealth가_정상적으로_받아지는지() {
        sutAPIManager.checkAPIHealth { result in
            switch result {
            case .success(let data):
                let apiHealth = String(data: data, encoding: .utf8)!
                XCTAssertEqual(apiHealth, "\"OK\"")
            case .failure:
                XCTFail()
            }
        }
    }

    func test_상품목록의_상품갯수가_20개인지_확인() {
        let response = JSONParser.decodeData(of: MockData().productListData, type: ProductList.self)
        sutAPIManager.checkProductList(pageNumber: 1, itemsPerPage: 20) { result in
            switch result {
            case .success(let data):
                let count = data.pages.count
                XCTAssertEqual(count, response?.pages.count)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func test_첫번째_상품의_이름이_pizza인지_확인() {
        let response = JSONParser.decodeData(of: MockData().productListData, type: ProductList.self)
        
        sutAPIManager.checkProductList(pageNumber: 1, itemsPerPage: 20) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.pages[0].name, response?.pages[0].name)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func test_네트워킹이_실패하는경우_에러가_정상적으로_나오는지() {
        sutAPIManager = .init(urlSession: MockURLSession(makeRequestFail: true))

        sutAPIManager.checkProductList(pageNumber: 1, itemsPerPage: 20) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error as! URLSessionError, URLSessionError.responseFailed(code: 410))
            }
        }
    }
    
    //    func test_아이디가_13인_상품의_상세조회_정상작동_확인() {
    //
    //        sutAPIManager.checkProductDetail(id: 13) { result in
    //            switch result {
    //            case .success(let data):
    //                let name = data.name
    //                XCTAssertEqual(name, "팥빙수")
    //            case .failure(let error):
    //                XCTAssertThrowsError(error)
    //            }
    //        }
    //    }
}

