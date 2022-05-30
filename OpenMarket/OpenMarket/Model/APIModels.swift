//
//  APIModels.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/16.
//
import Foundation

struct HealthCheckerAPI: APIable {
    let host = "https://market-training.yagom-academy.kr/"
    let path = "healthChecker"
    let params: [String : String]? = nil
    let method: HttpMethod = .get
    let itemComponents: ItemComponents? = nil
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
    let itemComponents: ItemComponents? = nil
}

struct ItemDetailAPI: APIable {
    let id: Int
    let host = "https://market-training.yagom-academy.kr/"
    var path: String {
        return "api/products/\(id)"
    }
    let params: [String : String]? = nil
    let method: HttpMethod = .get
    let itemComponents: ItemComponents? = nil
}

struct ItemImageAPI: APIable {
    var host: String
    var path = ""
    let params: [String : String]? = nil
    let method: HttpMethod = .get
    let itemComponents: ItemComponents? = nil
}

struct PostItemAPI: APIable {
    let host = "https://market-training.yagom-academy.kr/"
    let path = "api/products/"
    let params: [String : String]? = nil
    let method: HttpMethod = .post
    let itemComponents: ItemComponents?
}
