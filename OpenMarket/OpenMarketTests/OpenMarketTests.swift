//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by JeongTaek Han on 2022/01/03.
//

import XCTest

class OpenMarketTests: XCTestCase {
    
    var sutURLSessionProvider: URLSessionProvider!

    override func tearDownWithError() throws {
        sutURLSessionProvider = nil
    }
    
    private func setUpProvider(data: Data?, urlString: String, statusCode: Int) {
        guard let url = URL(string: urlString) else { return }
        
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: data, response: response, error: nil)
        let urlSession = StubURLSession(dummy: dummy)
        
        sutURLSessionProvider = URLSessionProvider(session: urlSession)
    }

    func test_URLSessionProvider에_showProductPage요청시_products_인스턴스를_정상적으로반환하는가() throws {
        //given
        //when
        setUpProvider(data: NSDataAsset(name: "products")?.data, urlString: "https://market-training.yagom-academy.kr/", statusCode: 200)
        
        //then
        sutURLSessionProvider.request(.showProductPage(pageNumber: "1", itemsPerPage: "10")) { (result: Result<ShowProductPageResponse, URLSessionProviderError>) in
            switch result {
            case .success(let data):
                print(data)
                XCTAssertTrue(true)
            case .failure(_):
                XCTFail("error")
            }
        }
    }
    
    func test_URLSessionProvider에_urlRequest가_정상적으로반환하는가() throws {
        //given
        //when
        setUpProvider(data: NSDataAsset(name: "products")?.data, urlString: "https://market-training.yagom-academy.kr/", statusCode: 200)
        
        //then
        let result = OpenMarketService.showProductPage(pageNumber: "1", itemsPerPage: "10").urlRequest
        
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products?page_no=1&items_per_page=10") else {
            XCTFail()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        XCTAssertEqual(result, request)
    }
}
