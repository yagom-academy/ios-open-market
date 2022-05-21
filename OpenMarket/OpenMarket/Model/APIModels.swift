//
//  APIModels.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/16.
//

struct HealthCheckerAPI: APIable {
    let host = "https://market-training.yagom-academy.kr/"
    let path = "healthChecker"
    let params: [String : String]? = nil
    let method: HttpMethod = .get
}

struct ItemPageAPI: APIable {
    let host = "https://market-training.yagom-academy.kr/"
    let path = "api/products/"
    let pageNumber: Int
    let itemPerPage: Int
    var params: [String : String]? {
        return [ "page_no" : String(pageNumber),
                 "items_per_page" : String(itemPerPage) ]
    }
    let method: HttpMethod = .get
}

struct ItemDetailAPI: APIable {
    let id: Int
    let host = "https://market-training.yagom-academy.kr/"
    var path: String {
        return "api/products/\(id)"
    }
    let params: [String : String]? = nil
    let method: HttpMethod = .get
}

struct ItemImageAPI: APIable {
    var host: String
    var path = ""
    var params: [String : String]? = nil
    var method: HttpMethod = .get
}
