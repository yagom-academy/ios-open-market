import XCTest

@testable import OpenMarket

class OpenMarketTests: XCTestCase {

    func testExample() throws {
        let productId = 16
        let url = URL(string: "https://market-training.yagom-academy.kr/api/products/\(productId)")!
        let session = StubURLSession(alwaysSuccess: true)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                return
            }
            XCTAssertTrue((200..<300) ~= response.statusCode)
        }.resume()
    }
    
    func test_ProductId가_16인_상품의이름은_팥빙수다() {
        let testSession = URLSession(configuration: .default)
        let url = URL(string: "https://market-training.yagom-academy.kr//api/products/16")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let promise = expectation(description: "getting data")
        
        testSession.request(urlRequest: request, expecting: ProductHTTPResponse.self) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.name, "팥빙수")
                promise.fulfill()
            case .failure:
                XCTAssertTrue(false)
            }
        }
        wait(for: [promise], timeout: 10)
    }
}
