//
//  MockURLSession.swift
//  OpenMarketTests
//
//  Created by Kyungmin Lee on 2021/01/28.
//

import UIKit
@testable import OpenMarket

enum JSONSample: String {
    case marketPage = "items"
    case marketItem = "item"
    case marketItemID = "id"
    
    var data: Data {
        guard let dataAsset = NSDataAsset(name: self.rawValue) else {
            print("failed to load DataAsset \(self.rawValue)")
            return Data()
        }
        return dataAsset.data
    }
}

class MockURLSession: URLSessionProtocol {
    var makeRequestFail = false
    var jsonSample: JSONSample
    
    init(makeRequestFail: Bool = false, jsonSample: JSONSample) {
        self.makeRequestFail = makeRequestFail
        self.jsonSample = jsonSample
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(url: OpenMarketAPIServerURL.postMarketItem.fullPath!, statusCode: 200, httpVersion: "2", headerFields: nil)
        let failurResponse = HTTPURLResponse(url: OpenMarketAPIServerURL.postMarketItem.fullPath!, statusCode: 410, httpVersion: "2", headerFields: nil)
        let urlSessionDataTask = MockURLSessionDataTask()

        urlSessionDataTask.resumeDidCall = {
            if self.makeRequestFail {
                completionHandler(nil, failurResponse, nil)
            } else {
                completionHandler(self.jsonSample.data, successResponse, nil)
            }
        }

        return urlSessionDataTask
    }
    
    func startDataTask<T>(_ requestData: RequestData<T>, completionHandler: @escaping (T?, Error?) -> Void) {
        dataTask(with: requestData.urlRequest) { (data, response, error) in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                completionHandler(data.flatMap(requestData.parseJSON), nil)
            } else {
                completionHandler(nil, error)
            }
        }.resume()
    }
}
