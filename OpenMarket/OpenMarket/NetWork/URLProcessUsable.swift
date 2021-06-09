//
//  URLProcessUsable.swift
//  OpenMarket
//
//  Created by 김민성 on 2021/06/05.
//

import Foundation

protocol URLProcessUsable {
    typealias URLInformation = (url: URL, urlMethod: String)
    
    func completedURL<T: Decodable>(model : T.Type, urlMethod: String, index: String?) -> URLInformation
    
    func requiredURLRequest(urlInformation : URLInformation, boundary: String?) -> URLRequest?
}
