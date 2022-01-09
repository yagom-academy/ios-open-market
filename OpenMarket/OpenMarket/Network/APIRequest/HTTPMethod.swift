//
//  HTTPMethod.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/09.
//

import Foundation

enum HTTPMethod {
    
    case GET
    case POST
    case PATCH
    case DELETE
    
    var decription: String {
        return "\(self)"
    }
    
}
