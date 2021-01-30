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
    
    init<Body: Encodable>(url: URL, httpMethod: HTTPMethod<Body>) {
        urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.method
        
        switch httpMethod {
        case .post(let body), .patch(let body), .delete(let body):
            urlRequest.httpBody = try? JSONEncoder().encode(body)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        default:
            break
        }
        
        parseJSON = { data in
            try? JSONDecoder().decode(T.self, from: data)
        }
    }
}
