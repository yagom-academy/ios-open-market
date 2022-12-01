//
//  OpenMarketAPI.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

enum ContentType: String {
    case json = "application/json"
    case image = "image/png"
}

enum HTTPMethod: String {
    case GET = "Get"
    case POST = "Post"
    case PATCH = "Patch"
    case DELETE = "Delete"
}

struct HttpBody {
    var key: String
    var contentType: ContentType
    var data: Data
    
    func createBody(_ id: String) -> Data {
        let boundary = "--Boundary-\(id)\r\n"
        let contentDataString = contentType == .json ? "Content-Disposition:form-data; name=\"\(key)\"\r\n" : "Content-Disposition:form-data; name=\"\(key)\"; filename=\"\(Date().description).png\"\r\n"
        let data = NSMutableData()
        data.appendString(boundary)
        data.appendString(contentDataString)
        data.appendString("Content-Type: \(contentType.rawValue)\r\n")
        data.append(self.data)
        data.appendString("\r\n")
        
        return data as Data
    }
}

extension NSMutableData {
    func appendString(_ value: String) {
        if let data = value.data(using: .utf8) {
            self.append(data)
        }
    }
}

enum OpenMarketAPI: APIType {

    case healthChecker
    case productsList(pageNumber: Int, rowCount: Int, searchValue: String = "")
    case productSearch(productId: Int)
    case addProduct(sendId: UUID, bodies: [HttpBody])
    
    var baseURL: String {
        return "https://openmarket.yagom-academy.kr"
    }
    
    var method: HTTPMethod {
        switch self {
        case .healthChecker, .productsList, .productSearch:
            return .GET
        case .addProduct:
            return .POST
        }
    }
    
    
    var path: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .productsList(_, _, _):
            return "/api/products"
        case .productSearch(let productId):
            return "/api/products/\(productId)"
        case .addProduct(_, _):
            return "/api/products"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .productsList(let pageNumber, let rowCount, let searchValue):
            return [
                "page_no": pageNumber.description,
                "items_per_page": rowCount.description,
                "search_value": searchValue
            ]
        default:
            return [:]
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .addProduct(let id, _):
            return [
                "identifier": "d94a4ffb-6941-11ed-a917-a7e99e3bb892",
                "Content-Type": "multipart/form-data; boundary=\(id.uuidString)"
            ]
        default:
            return [:]
        }
    }
    
    var body: Data {
        var value: Data = Data()
        switch self {
        case .addProduct(let id, let bodies):
            bodies.forEach {
                value.append($0.createBody(id.uuidString))
            }
            
            return value
        default:
            return Data()
        }
    }
    
    func generateURL() -> URL? {
        guard var baseComponents = URLComponents(string: baseURL) else {
            return nil
        }
        
        baseComponents.path = path
        baseComponents.queryItems = parameters.asParameters()
        
        return baseComponents.url
    }
}
