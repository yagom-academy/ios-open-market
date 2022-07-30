//
//  URLCollection.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/12.
//

enum URLCollection {
    static let healthChecker = "https://market-training.yagom-academy.kr/healthChecker"
    static let productListInquery = "https://market-training.yagom-academy.kr/api/products?page_no=1&"
    static let productDetailInquery = "https://market-training.yagom-academy.kr/api/products/3541"
    static let productUploadInquery = "https://market-training.yagom-academy.kr/api/products"
}

enum VendorInfo {
    static let identifier = "fa69efb9-0335-11ed-9676-1db1453669a0"
    static let secret = "aJo1WTMl7u"
}

enum HTTPMethod {
    static let post = "POST"
    static let put = "PUT"
    static let get = "GET"
    static let delete = "DELETE"
}


