//
//  StubURLSession.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/10.
//

import Foundation
@testable import OpenMarket

struct DummyData {
    var response: Response
    var completionHandler: DataTaskCompletionHandler?
}

struct StubURLSession: URLSessionProtocol {
    var dummyData: DummyData?
    
    init(dummy: DummyData) {
        self.dummyData = dummy
    }
    
    func dataTask(with api: APIable, completionHandler: @escaping DataTaskCompletionHandler) {
        guard let statusCode = dummyData?.response.statusCode else {
            return
        }
        
        let response = Response(data: dummyData?.response.data, statusCode: statusCode, error: dummyData?.response.error)
        
        completionHandler(response)
    }
}
