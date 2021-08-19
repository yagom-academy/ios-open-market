//
//  MockURLSession.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/18.
//

import Foundation

//class MockURLSession: URLSessionProtocol {
//    var url = URL(string: ApiFormat.getItem.url)!
//
//    var isRequestSucess: Bool
//    let sessionDataTask = MockURLSessionDataTask()
//
//    init(isRequestSucess: Bool) {
//        self.isRequestSucess = isRequestSucess
//    }
//
//    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//        let successResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil)
//        let failureResponse = HTTPURLResponse(url: url, statusCode: 402, httpVersion: "2", headerFields: nil)
//        
//        if isRequestSucess {
//            let sampleData = try? MockJsonDecoder.receiveDataAsset(assetName: "MockItem").data
//            sessionDataTask.resumeDidCall = { completionHandler(sampleData, successResponse, nil) }
//        } else {
//            sessionDataTask.resumeDidCall = { completionHandler(nil, failureResponse, nil) }
//        }

//        return sessionDataTask
//    }
//}
