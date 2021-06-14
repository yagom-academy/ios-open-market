//
//  MockURLSession.swift
//  OpenMarketTest
//
//  Created by 김찬우 on 2021/06/08.
//

import Foundation
import UIKit
@testable import OpenMarket

enum CaseOfResponse {
    case statusCode403
    case nonHTTPResponse
    case rightCase
}

class MockURLSession: URLSessionProtocol {
    var mockURLSessionDataTask = MockURLSessionDataTask()
    let caseOfResponse: CaseOfResponse
    let sampleData = NSDataAsset(name: "Item")!.data

    let successResponse = HTTPURLResponse(url: GETRequest(page: 1, id: 1, descriptionAboutMenu: .상품조회).urlRequest.url!,
                                          statusCode: 200,
                                          httpVersion: "2",
                                          headerFields: nil)

    let statusErrorResponse = HTTPURLResponse(url: GETRequest(page: 1, id: 1, descriptionAboutMenu: .상품조회).urlRequest.url!,
                                              statusCode: 403,
                                              httpVersion: "2",
                                              headerFields: nil)

    init(caseOfResponse: CaseOfResponse){
        self.caseOfResponse = caseOfResponse
    }

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        switch caseOfResponse {
        case .rightCase:
            mockURLSessionDataTask.resumeDidCall = { completionHandler(self.sampleData, self.successResponse, nil) }
            return mockURLSessionDataTask
        case .statusCode403:
            mockURLSessionDataTask.resumeDidCall = { completionHandler(nil, self.statusErrorResponse, nil) }
            return mockURLSessionDataTask
        case .nonHTTPResponse:
            mockURLSessionDataTask.resumeDidCall = { completionHandler(nil, nil, nil) }
            return mockURLSessionDataTask
        }
    }
}
