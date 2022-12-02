//
//  OpenMarketAPI.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

struct Parameters: Encodable {
    let name: String
    let description: String
    let price: Double
    let currency: Currency
    let discounted_price: Double
    let stock: Int
    let secret: String
}


enum ContentType: String {
    case json = "application/json"
    case image = "image/jpg"
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

struct HttpBody {
    var key: String
    var contentType: ContentType
    var data: Data
    
    func createBody(_ id: String) -> Data {
        let boundary = "--Boundary-\(id)\r\n"
        let data = NSMutableData()
        data.appendString(boundary)
        
        if contentType == .json {
            data.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n")
        } else {
            data.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"minii.jpg\"\r\n")
        }
        
        data.appendString("Content-Type: \(contentType.rawValue)\r\n\r\n")
        
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
    
    var parameters: [String : String]? {
        switch self {
        case .productsList(let pageNumber, let rowCount, let searchValue):
            return [
                "page_no": pageNumber.description,
                "items_per_page": rowCount.description,
                "search_value": searchValue
            ]
        default:
            return nil
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .addProduct(let id, _):
            return [
                "identifier": "5fcfb895-6942-11ed-a917-1385e44824d5",
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
            
            value.append("--Boundary-\(id.uuidString)--".data(using: .utf8)!)
            
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
        
        if let parameters = parameters {
            baseComponents.queryItems = parameters.asParameters()
        }
        
        return baseComponents.url
    }
}
