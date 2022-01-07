//
//  APIRequest.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/07.
//

import Foundation

protocol APIRequest {
    
    var finalURL: String { get }
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
    var urlRequest: URLRequest? { get }
    
}

extension APIRequest {
    
    var baseURL: String {
        return "https://market-training.yagom-academy.kr"
    }

    var finalURL: String {
        return baseURL + path
    }
    
}
