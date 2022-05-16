//
//  EndPoint.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/16.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum EndPoint {
    case serverState(httpMethod: HTTPMethod, sendData: Encodable? = nil)
    case requestList(page: Int, itemsPerPage: Int, httpMethod: HTTPMethod, sendData: Encodable? = nil)
    case requestProduct(id: Int, httpMethod: HTTPMethod, sendData: Encodable? = nil)
}

extension EndPoint {
    private static var host: String {
        "https://market-training.yagom-academy.kr/"
    }
    
    var url: URL? {
        switch self {
        case .serverState:
            return URL(string: Self.host + "healthChecker")
        case .requestList(let page, let itemsPerPage, _, _):
            return URL(string: Self.host + "api/products?items_per_page=\(itemsPerPage)&page_no=\(page)")
        case .requestProduct(let id, _, _):
            return URL(string: Self.host + "api/products/\(id)")
        }
    }
    
    var urlRequst: URLRequest? {
        switch self {
        case .serverState(let httpMethod, let sendData):
            return makeUrlRequest(httpMethod: httpMethod, sendData: sendData)
        case .requestList(_, _, let httpMethod, let sendData):
            return makeUrlRequest(httpMethod: httpMethod, sendData: sendData)
        case .requestProduct(_, let httpMethod, let sendData):
            return makeUrlRequest(httpMethod: httpMethod, sendData: sendData)
        }
    }
    
    private func makeUrlRequest(httpMethod: HTTPMethod, sendData: Encodable? = nil) -> URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = sendData?.encodeData()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
