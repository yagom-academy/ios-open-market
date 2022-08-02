//
//  RequestName.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

enum RequestName: String {
    case identifier = "identifier"
    case params = "params"
    case images = "images"
    
    var key: String {
        return self.rawValue
    }
}
