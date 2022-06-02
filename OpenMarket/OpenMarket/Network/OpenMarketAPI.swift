//
//  OpenMarketAPI.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/06/02.
//

import Foundation

struct CreateProduct: APIable {
    let baseURL: String = "https://market-training.yagom-academy.kr/api/products/"
    let path: String = ""
    let method: HTTPMethod = .post
    let queryParameters: [String : String]? = nil
    let bodyParameters: Encodable?
    let headers: [String : String] = [
        "Content-Type": "multipart/form-data; boundary=\(EndPoint.boundary)",
        "identifier": UserInformation.identifier
    ]
}
