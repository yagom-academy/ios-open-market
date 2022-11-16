//
//  OpenMarketNetworkRequest.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

struct HealthCheckerRequest: NetworkRequest {
    let httpMethod: HttpMethod = .get
    let urlHost: String = "https://openmarket.yagom-academy.kr/"
    let urlPath: String = "healthChecker"
    var queryParameters: [String : String] = [:]
}

struct ProductListRequest: NetworkRequest {
    let httpMethod: HttpMethod = .get
    let urlHost: String = "https://openmarket.yagom-academy.kr/"
    let urlPath: String = "api/products"
    var queryParameters: [String : String] = [:]
    
    init(pageNo: Int, itemsPerPage: Int, searchValue: String = "") {
        self.queryParameters["page_no"] = String(pageNo)
        self.queryParameters["items_per_page"] = String(itemsPerPage)
        if !searchValue.isEmpty {
            self.queryParameters["search_value"] = String(searchValue)
        }
    }
}

struct ProductDetailRequest: NetworkRequest {
    let httpMethod: HttpMethod = .get
    let urlHost: String = "https://openmarket.yagom-academy.kr/"
    let urlPath: String
    var queryParameters: [String : String] = [:]
    
    init(productID: Int) {
        self.urlPath = "api/products/\(productID)"
    }
}
