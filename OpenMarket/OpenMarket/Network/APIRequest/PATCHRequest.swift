//
//  PATCHRequest.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/07.
//

import Foundation

protocol PATCHRequest: APIRequest {
    
    var header: [String: String] { get }
    var body: [String: Any] { get }
    
}

extension PATCHRequest {
    
    var method: String { return "PATCH" }
    
}
