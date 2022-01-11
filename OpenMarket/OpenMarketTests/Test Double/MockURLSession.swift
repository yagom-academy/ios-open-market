import Foundation
import UIKit

class MockURLSession: URLSessionProtocol {
    var makeRequestFail = false

    init(makeRequestFail: Bool = false) {
        self.makeRequestFail = makeRequestFail
    }

    var sessionDataTask: MockURLSessionDataTask?

    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        let url = URL(string: HTTPUtility.baseURL)!
        let successResponse = HTTPURLResponse(url: url,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        let failureResponse = HTTPURLResponse(url: url,
                                              statusCode: 410,
                                              httpVersion: nil,
                                              headerFields: nil)
        let sessionDataTask = MockURLSessionDataTask()

        sessionDataTask.resumeDidCall = {
            if self.makeRequestFail {
                completionHandler(nil, failureResponse, nil)
            } else {
                let data = NSDataAsset(name: "products", bundle: .main)?.data
                completionHandler(data, successResponse, nil)
            }
        }
        return sessionDataTask
    }

}
