import Foundation
@testable import OpenMarket

class MockURLSession: URLSessionProtocol {
    let isSuccess: Bool
    
    init(isSuccess: Bool = true) {
        self.isSuccess = isSuccess
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let url = URL(string: "https://market-training.yagom-academy.kr/api/products/15")
        let successResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        let failResponse = HTTPURLResponse(url: url!, statusCode: 400, httpVersion: "HTTP/1.1", headerFields: nil)
        
        let data = Bundle.main.path(forResource: "products", ofType: "json")
        let productData = try! String(contentsOfFile: data!).data(using: .utf8)

        let task = MockURLSessionDataTask(taskCompletion: {
            if self.isSuccess {
                completionHandler(productData, successResponse, nil)
            } else {
                completionHandler(nil, failResponse, APIError.invalidRequest)
            }
        })
        
        return task
    }
}
