//
//  EndPoint.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/16.
//

import Foundation

private enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum EndPoint {
    case serverState
    case requestList(page: Int, itemsPerPage: Int)
    case requestProduct(id: Int)
    case editProduct(id: Int, sendData: UploadProduct)
    case createProduct(sendData: Data)
    
    static let boundary = UUID().uuidString
    private static let host = "https://market-training.yagom-academy.kr/"
}

extension EndPoint {
    private var url: URL? {
        switch self {
        case .serverState:
            return URL(string: Self.host + "healthChecker")
        case .requestList(let page, let itemsPerPage):
            return URL(string: Self.host + "api/products?items_per_page=\(itemsPerPage)&page_no=\(page)")
        case .requestProduct(let id):
            return URL(string: Self.host + "api/products/\(id)")
        case .editProduct(let id, _):
            return URL(string: Self.host + "api/products/\(id)")
        case .createProduct(_):
            return URL(string: Self.host + "api/products")
        }
    }
    
    private var httpMethod: HTTPMethod {
        switch self {
        case .serverState, .requestList(_, _), .requestProduct(_):
            return .get
        case .editProduct(_, _):
            return .patch
        case .createProduct(_):
            return .post
        }
    }

    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        switch self {
        case .serverState, .requestList(_, _),.requestProduct(_):
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        case .editProduct(_, let sendData):
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(UserInformation.identifier, forHTTPHeaderField: "identifier")
            request.httpBody = try? JSONEncoder().encode(sendData)
        case .createProduct(let sendData):
            request.addValue("multipart/form-data; boundary=\(Self.boundary)", forHTTPHeaderField: "Content-Type")
            request.addValue(UserInformation.identifier, forHTTPHeaderField: "identifier")
            request.httpBody = sendData
        }
        
        return request
    }
}
