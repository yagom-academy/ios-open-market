//
//  URLCommand.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/12.
//

enum URLData {
    static let host = "https://market-training.yagom-academy.kr"
    static let apiPath = "/api/products"
    static let identifier = "e4c0e472-0335-11ed-9676-05ce201d7309"
    static let secret = "p0ilm9kwYb"
}

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case PUT = "PUT"
}

