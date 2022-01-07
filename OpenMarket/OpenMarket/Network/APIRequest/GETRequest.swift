//
//  GETRequest.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/07.
//

import Foundation

protocol GETRequest: APIRequest {
    
}

extension GETRequest {
    
    var method: String { return "GET" }
    
}
