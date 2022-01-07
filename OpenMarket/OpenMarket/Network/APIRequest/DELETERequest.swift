//
//  DELETERequest.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/07.
//

import Foundation

protocol DELETERequest: APIRequest {
    
    var header: [String: String] { get }
    
}

extension DELETERequest {
    
    var method: String { return "DELETE" }
    
}
