//
//  NetworkDispatcher.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/09/03.
//

import Foundation

struct NetworkDispatcher {
    private let session: URLSessionProtocol
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func prepareForRequest(of request: Request, _ suffix: String) -> Result<URLRequest, Error> {
        guard let url = URL(string: Request.baseURL + request.path + suffix) else {
            fatalError()
        }
        let userRequest = URLRequest(url: url)
        return .success(userRequest)
    }
}
