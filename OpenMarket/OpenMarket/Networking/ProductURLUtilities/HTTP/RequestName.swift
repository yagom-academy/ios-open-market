//
//  RequestName.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/07/27.
//

enum RequestName: String {
    case identifier = "identifier"
    case params = "params"
    case images = "images"
    
    var key: String {
        return self.rawValue
    }
}
