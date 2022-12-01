//
//  OpenMarketNetworkRequest.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import UIKit

struct HealthCheckerRequest: NetworkRequest {
    let httpMethod: HttpMethod = .get
    let urlHost: String = "https://openmarket.yagom-academy.kr"
    let urlPath: String = "/healthChecker"
    let queryParameters: [String: String] = [:]
    let httpHeader: [String: String]?
    let httpBody: Data?
}

struct ProductListRequest: NetworkRequest {
    let httpMethod: HttpMethod = .get
    let urlHost: String = "https://openmarket.yagom-academy.kr"
    let urlPath: String = "/api/products"
    let queryParameters: [String: String]
    let httpHeader: [String: String]? = nil
    let httpBody: Data? = nil
    
    init(pageNo: Int, itemsPerPage: Int, searchValue: String = "") {
        var queryParameters: [String: String] = [:]
        
        queryParameters = [
            "page_no": String(pageNo),
            "items_per_page": String(itemsPerPage)
        ]
        if !searchValue.isEmpty {
            queryParameters["search_value"] = String(searchValue)
        }
        self.queryParameters = queryParameters
    }
}

struct ProductDetailRequest: NetworkRequest {
    let httpMethod: HttpMethod = .get
    let urlHost: String = "https://openmarket.yagom-academy.kr"
    let urlPath: String
    let queryParameters: [String: String] = [:]
    let httpHeader: [String: String]? = nil
    let httpBody: Data? = nil
    
    init(productID: Int) {
        self.urlPath = "/api/products/\(productID)"
    }
}

struct ProductAddRequest: NetworkRequest {
    let httpMethod: HttpMethod = .post
    let urlHost: String = "https://openmarket.yagom-academy.kr"
    let urlPath: String = "/api/products"
    let queryParameters: [String: String] = [:]
    let httpHeader: [String: String]?
    let httpBody: Data?
    
    init(identifier: String, params: Data, images: Data) {
        var body = Data()
        var header: [String: String] = [:]
        let boundary = "----\(UUID().uuidString)"
        let lineBreak = "\r\n"
    
        header["identifier"] = identifier
        header["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        
        body.append("--" + boundary + lineBreak, using: .utf8)
        body.append("Content-Disposition:form-data; name=\"params\"" + lineBreak, using: .utf8)
        body.append("Content-Type: application/json" + lineBreak, using: .utf8)
        body.append(lineBreak, using: .utf8)
        body.append(params)
        body.append(lineBreak, using: .utf8)
        body.append("--" + boundary + lineBreak, using: .utf8)
        body.append("Content-Disposition:form-data; name=\"images\"; filename=\"image.jpeg\"" + lineBreak, using: .utf8)
        body.append("Content-Type: image/jpeg" + lineBreak, using: .utf8)
        body.append(lineBreak, using: .utf8)
        body.append(images)
        body.append(lineBreak, using: .utf8)
        body.append("--" + boundary + "--", using: .utf8)
        
        self.httpHeader = header
        self.httpBody = body
    }
}

struct ProductEditRequest: NetworkRequest {
    let httpMethod: HttpMethod = .patch
    let urlHost: String = "https://openmarket.yagom-academy.kr"
    let urlPath: String
    let queryParameters: [String : String] = [:]
    let httpHeader: [String : String]?
    let httpBody: Data?
    
    init(identifier: String,
         editProduct: EditProduct) {
        let data = JSONEncoder.encode(from: editProduct)
        var header: [String: String] = [:]
        header["identifier"] = identifier
        
        self.urlPath = "/api/products/\(editProduct.productID)"
        self.httpHeader = header
        self.httpBody = data
    }
}

struct URISearchRequest: NetworkRequest {
    let httpMethod: HttpMethod = .post
    let urlHost: String = "https://openmarket.yagom-academy.kr"
    let urlPath: String
    let queryParameters: [String : String] = [:]
    let httpHeader: [String : String]?
    let httpBody: Data?
    
    init(productID: Int, identifier: String, secret: String) {
        let body: String = "{\"secret\":\"\(secret)\"}"
        var header: [String: String] = [:]
        header["identifier"] = identifier
        
        self.urlPath = "/api/products/\(productID)/archived"
        self.httpHeader = header
        self.httpBody = body.data(using: .utf8)
    }
}

struct ProductDeleteRequest: NetworkRequest {
    let httpMethod: HttpMethod = .delete
    let urlHost: String = "https://openmarket.yagom-academy.kr"
    let urlPath: String
    let queryParameters: [String : String] = [:]
    let httpHeader: [String : String]?
    let httpBody: Data? = nil
    
    init(identifier: String, uri: String) {
        var header: [String: String] = [:]
        header["identifier"] = identifier
        
        self.urlPath = "/api/products/\(uri)"
        self.httpHeader = header
    }
}
