
import Foundation
import XCTest
@testable import OpenMarket

class MockURLSession: URLSessionProtocol {

    var makeRequestFail = false
    
    init(makeRequestFail: Bool = false) {
        self.makeRequestFail = makeRequestFail
    }
    
    var sessionDataTask: MockURLSessionDataTask?
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(url: MockAPI.test.listPageOneURL,
                                              statusCode: 200,
                                              httpVersion: "1.1",
                                              headerFields: nil)
        let failureResponse = HTTPURLResponse(url: MockAPI.test.listPageOneURL,
                                              statusCode: 410,
                                              httpVersion: "1.1",
                                              headerFields: nil)
        
        let sessionDataTask = MockURLSessionDataTask()
        
        sessionDataTask.resumeDidCall = {
            if self.makeRequestFail {
                completionHandler(nil, failureResponse, nil)
            } else {
                completionHandler(MockAPI.test.sampleItems.data, successResponse, nil)
            }
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
    
    var sessionUploadTask: MockURLSessionUploadTask?
    func uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask {
        let successResponse = HTTPURLResponse(url: MockAPI.test.postProductURL,
                                              statusCode: 200,
                                              httpVersion: "1.1",
                                              headerFields: nil)
        let failureResponse = HTTPURLResponse(url: MockAPI.test.postProductURL,
                                              statusCode: 410,
                                              httpVersion: "1.1",
                                              headerFields: nil)

        let sessionUploadTask = MockURLSessionUploadTask()

        sessionUploadTask.resumeDidCall = {
            if self.makeRequestFail {
                completionHandler(nil, failureResponse, nil)
            } else {
                completionHandler(MockAPI.test.sampleItem.data, successResponse, nil)
            }
        }
        self.sessionUploadTask = sessionUploadTask
        return sessionUploadTask
    }
    
}
