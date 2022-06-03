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
    let password: String? = nil
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
    let password: String? = nil
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
    let password: String? = nil
}

struct ItemImageAPI: APIable {
    var host: String
    var path = ""
    let params: [String : String]? = nil
    let method: HttpMethod = .get
    let itemComponents: ItemComponents? = nil
    let password: String? = nil
}

struct PostItemAPI: APIable {
    let host = "https://market-training.yagom-academy.kr/"
    let path = "api/products/"
    let params: [String : String]? = nil
    let method: HttpMethod = .post
    let itemComponents: ItemComponents?
    let password: String? = nil
}

struct SecretAPI: APIable {
    let id: Int
    let host = "https://market-training.yagom-academy.kr/"
    var path: String {
        return "api/products/\(id)/secret"
    }
    var params: [String : String]? = nil
    var method: HttpMethod = .post
    var itemComponents: ItemComponents? = nil
    let password: String?
}

struct DeleteAPI: APIable {
    let id: Int
    let secret: String
    let host = "https://market-training.yagom-academy.kr/"
    var path: String {
        return "api/products/\(id)/\(secret)"
    }
    let params: [String : String]? = nil
    let method: HttpMethod = .delete
    let itemComponents: ItemComponents? = nil
    let password: String? = nil
}

struct PatchAPI: APIable {
    let id: Int
    let host = "https://market-training.yagom-academy.kr/"
    var path: String {
        return "api/products/\(id)"
    }
    let params: [String : String]? = nil
    let method: HttpMethod = .patch
    var itemComponents: ItemComponents?
    let password: String? = nil
}
