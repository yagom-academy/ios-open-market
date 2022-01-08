import Foundation

class MockURLSession: URLSessionProtocol {
    
    let sessionDataTask = MockURLSessionDataTask()
    var makeRequestFail = false
    
    init(makeRequestFail: Bool = false) {
        self.makeRequestFail = makeRequestFail
    }

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        let successResponse = HTTPURLResponse(url: request.url!,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)

        let failureResponse = HTTPURLResponse(url: request.url!,
                                              statusCode: 410,
                                              httpVersion: "2",
                                              headerFields: nil)
        sessionDataTask.resumeDidCall = {
            if request.url == URLManager.healthChecker.url {
                completionHandler(MockData().healthData, successResponse, nil)
                return
            }
            
            if self.makeRequestFail {
                completionHandler(nil, failureResponse, nil)
            } else {
                completionHandler(MockData().productListData, successResponse, nil)
            }
        }
        return sessionDataTask
    }
    
}
