//  Created by Aejong, Tottale on 2022/11/17.

import UIKit

final class MockURLSession: URLSessionProtocol {
    
    var makeRequestFail = false
    var sampleData: Data
    
    init(makeRequestFail: Bool = false, sampleData: Data) {
        self.makeRequestFail = makeRequestFail
        self.sampleData = sampleData
    }
    
    var sessionDataTask: MockURLSessionDataTask?
    
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        guard let url: URL = NetworkAPI.productList(query: nil).urlComponents.url else {
            return MockURLSessionDataTask()
        }
        
        let successResponse = HTTPURLResponse(url: url,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        
        let failureResponse = HTTPURLResponse(url: url,
                                              statusCode: 410,
                                              httpVersion: "2",
                                              headerFields: nil)

        let sessionDataTask = MockURLSessionDataTask()
        
        sessionDataTask.resumeDidCall = {
            if self.makeRequestFail {
                completionHandler(nil, failureResponse, nil)
            } else {
                completionHandler(self.sampleData, successResponse, nil)
            }
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}
