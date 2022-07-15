//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let address = NetworkNamespace.url.name
        let pageNo = URLQueryItem(name: NetworkNamespace.pageNo.name, value: "1")
        let itemsPerPage = URLQueryItem(name: NetworkNamespace.itemsPerPage.name, value: "10")
        let queryItems = [pageNo, itemsPerPage]
        
        getProductList(address: address, queryItems: queryItems, httpMethod: NetworkNamespace.get.name)
    }
    
    private func getProductList(address: String, queryItems: [URLQueryItem], httpMethod: String) {
        let session = URLSession(configuration: .default)
        let netWorkManager = NetworkManager(session: session)
        var components = URLComponents(string: address)
        
        guard let url = components?.url else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod
        components?.queryItems = queryItems
    }
}
