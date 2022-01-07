//
//  POSTRequest.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/07.
//

import Foundation

protocol POSTRequest: APIRequest {
    
    var header: [String: String] { get }
    var body: [String: Any] { get }
    var boundary: String { get }
    
}

extension POSTRequest {
    
    var method: String { return "POST" }
    var urlRequest: URLRequest? {
        guard let url = URL(string: finalURL) else { return nil }
        let request = URLRequest(url: url)
        request.addValue(<#T##value: String##String#>, forHTTPHeaderField: <#T##String#>)
        return request
    }
}
