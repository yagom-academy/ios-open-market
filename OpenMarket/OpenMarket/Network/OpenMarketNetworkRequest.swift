//
//  OpenMarketNetworkRequest.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

struct HealthCheckerRequest: NetworkRequest {
    let httpMethod: HttpMethod = .get
    let urlHost: String = "https://openmarket.yagom-academy.kr"
    let urlPath: String = "healthChecker"
    var queryParameters: [String : String] = [:]
}

struct ProductListRequest: NetworkRequest {
    private let pageNo: Int
    private let itemsPerPage: Int
    private let searchValue: String
    let httpMethod: HttpMethod = .get
    let urlHost: String = "https://openmarket.yagom-academy.kr"
    let urlPath: String = "api/products"
    var queryParameters: [String : String] = [:]
    
    init(pageNo: Int, itemsPerPage: Int, searchValue: String = "") {
        self.pageNo = pageNo
        self.itemsPerPage = itemsPerPage
        self.searchValue = searchValue
    }
}

struct ProductDetailRequest: NetworkRequest {
    let httpMethod: HttpMethod = .get
    let urlHost: String = "https://openmarket.yagom-academy.kr"
    let urlPath: String
    var queryParameters: [String : String] = [:]
    
    init(productID: Int) {
        self.urlPath = "api/products/\(productID)"
    }
}
