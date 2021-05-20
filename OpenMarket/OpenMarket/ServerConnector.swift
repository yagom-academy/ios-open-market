//
//  URLSession.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/20.
//

import Foundation

struct ServerConnector {
    let domain: String
    let url: URL
    let urlRequest: URLRequest
    
    init(domain: String) {
        self.domain = domain
        self.url = URL(string: domain)!
        self.urlRequest = URLRequest(url: url)
    }
    
    func getServersData() {}
    
    func postClientsData() {}
    
    func patchSeversData() {}
    
    func deleteServersData() {}
} 
