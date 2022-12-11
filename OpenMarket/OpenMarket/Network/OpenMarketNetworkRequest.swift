//
//  OpenMarketNetworkRequest.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation

struct HealthCheckerRequest: NetworkRequest {
    let httpMethod: HttpMethod = .get
    let urlHost: String = "http://openmarket.yagom-academy.kr"
    let urlPath: String = "/healthChecker"
    let queryParameters: [String: String] = [:]
    let httpHeader: [String: String]?
    let httpBody: Data?
}

struct ProductListRequest: NetworkRequest {
    let httpMethod: HttpMethod = .get
    let urlHost: String = "http://openmarket.yagom-academy.kr"
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
    let urlHost: String = "http://openmarket.yagom-academy.kr"
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
    let urlHost: String = "http://openmarket.yagom-academy.kr"
    let urlPath: String = "/api/products"
    let queryParameters: [String: String] = [:]
    var httpHeader: [String: String]?
    var httpBody: Data?
    
    init(from multipartFormData: MultipartFormData) {
        self.httpHeader = multipartFormData.fetchHTTPHeader()
        self.httpBody = multipartFormData.fetchHTTPBody()
    }
}

struct ProductEditRequest: NetworkRequest {
    let httpMethod: HttpMethod = .patch
    let urlHost: String = "http://openmarket.yagom-academy.kr"
    let urlPath: String
    let queryParameters: [String : String] = [:]
    let httpHeader: [String : String]?
    let httpBody: Data?
    
    init(identifier: String,
         editProduct: SendingProduct) {
        let data = JSONEncoder.encode(from: editProduct)
        var header: [String: String] = ["Content-Type": "application/json"]
        header["identifier"] = identifier
        
        self.urlPath = "/api/products/\(editProduct.productID ?? 0)"
        self.httpHeader = header
        self.httpBody = data
    }
}

struct URISearchRequest: NetworkRequest {
    let httpMethod: HttpMethod = .post
    let urlHost: String = "http://openmarket.yagom-academy.kr"
    let urlPath: String
    let queryParameters: [String : String] = [:]
    let httpHeader: [String : String]?
    let httpBody: Data?
    
    init(productID: Int, identifier: String, secret: String) {
        let body: Secret = Secret(secret: secret)
        var header: [String: String] = ["Content-Type": "application/json"]
        header["identifier"] = identifier
        
        self.urlPath = "/api/products/\(productID)/archived"
        self.httpHeader = header
        self.httpBody = JSONEncoder.encode(from: body)
    }
}

struct ProductDeleteRequest: NetworkRequest {
    let httpMethod: HttpMethod = .delete
    let urlHost: String = "http://openmarket.yagom-academy.kr"
    let urlPath: String
    let queryParameters: [String : String] = [:]
    let httpHeader: [String : String]?
    let httpBody: Data? = nil
    
    init(identifier: String, uri: String) {
        var header: [String: String] = [:]
        header["identifier"] = identifier
        
        self.urlPath = uri
        self.httpHeader = header
    }
}
