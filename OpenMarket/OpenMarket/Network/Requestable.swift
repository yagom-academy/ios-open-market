//
//  Requestable.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/30.
//

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String] { get }
    var bodyParameters: [BodyParameter]? { get set }
}

extension Requestable {
    var baseURL: String {
        return "https://openmarket.yagom-academy.kr"
    }
}
