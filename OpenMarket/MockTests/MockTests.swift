//
//  MockTests.swift
//  MockTests
//
//  Created by 데릭, 케이, 수꿍.
//

import XCTest
@testable import OpenMarket

class MockTests: XCTestCase {
    var sut: APIClient!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = APIClient(session: URLSession.shared)
    }
    
    override func tearDownWithError() throws {
        try super.setUpWithError()
        sut = nil
    }
    
    func test_fetchData_메서드가_status_code가_200일때_mock_data를_예상한_값과_동일하게_가져오는지_테스트() throws {
        // given
        guard let path = Bundle.main.path(forResource: "Mock", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path),
              let data = jsonString.data(using: .utf8) else {
            return
        }
        
        let decodedData = try? JSONDecoder().decode(ProductList.self, from: data)
        
        let expectation: ProductList? = decodedData
        let url = "https://market-training.yagom-academy.kr/"
        let mockResponse: MockURLSession.Response = {
            let successResponse = HTTPURLResponse(url: URL(string: url)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (data: data, urlResponse: successResponse, error: nil)
        }()
        
        var result: ProductList?
        let mockURLSession = MockURLSession(response: mockResponse)
        sut = APIClient(session: mockURLSession)
        
        // when
        sut.requestAndDecode(url: url, dataType: ProductList.self) { response in
            if case let .success(market) = response {
                result = market
            }
        }
        
        // then
        XCTAssertEqual(expectation?.pages.count, result?.pages.count)
    }
    
    func test_fetchData_메서드가_status_code가_500일때_networkConnectionIsBad_errorDescription을_반환하는지_테스트() throws {
        // given
        let expectation = NetworkError.networkConnectionIsBad.errorDescription
        
        let url = "https://market-training.yagom-academy.kr/"
        let mockResponse: MockURLSession.Response? = {
            guard let path = Bundle.main.path(forResource: "Mock", ofType: "json"),
                  let jsonString = try? String(contentsOfFile: path),
                  let data = jsonString.data(using: .utf8) else {
                return nil
            }
            
            let successResponse = HTTPURLResponse(url: URL(string: url)!, statusCode: 500, httpVersion: nil, headerFields: nil)
            return (data: data, urlResponse: successResponse, error: nil)
        }()
        
        let mockURLSession = MockURLSession(response: mockResponse!)
        sut = APIClient(session: mockURLSession)
        
        // when
        sut.requestAndDecode(url: url, dataType: ProductList.self) { response in
            switch response {
            case .success(_):
                break
            case .failure(let error):
                // then
                XCTAssertEqual(expectation, error.errorDescription)
            }
        }
    }
}
