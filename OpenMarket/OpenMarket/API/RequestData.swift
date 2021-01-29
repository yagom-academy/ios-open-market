//
//  RequestData.swift
//  OpenMarket
//
//  Created by Kyungmin Lee on 2021/01/30.
//

import Foundation

struct RequestData<T: Decodable> {
    var urlRequest: URLRequest
    let parseJSON: (Data) -> T?
    
    init(url: URL) {
        urlRequest = URLRequest(url: url)
        parseJSON = { data in
            try? JSONDecoder().decode(T.self, from: data)
        }
    }
}
