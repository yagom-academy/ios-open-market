//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let address = "https://market-training.yagom-academy.kr/api/products"
        let pageNo = URLQueryItem(name: "pageNo", value: "1")
        let itemsPerPage = URLQueryItem(name: "itemsPerPage", value: "10")
        let queryItems = [pageNo, itemsPerPage]
        
        getProductList(address: address, queryItems: queryItems, httpMethod: "GET")
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
        
        netWorkManager.fetch(request: request, dataType: MarketInformation.self) { result in
            switch result {
            case .success(let product):
                print(product)
            case . failure(let error):
                print(error)
            }
        }
     }
}
