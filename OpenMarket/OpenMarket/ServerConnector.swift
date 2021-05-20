//
//  URLSession.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/20.
//

import Foundation

struct ServerConnector {
    let url: URL
    let urlRequest : URLRequest
    
    init(url: URL, method: String) {
        self.url = url
        self.urlRequest = URLRequest(url: url)
    }
    
    func getServersData() {}
    
    func postClientsData() {}
    
    func patchSeversData() {}
    
    func deleteServersData() {}
}

