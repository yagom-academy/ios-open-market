//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProductList(about: "3", "1")
    }
    
    private func getProductList(about pageNumber: String, _ itemPerPage: String) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let networkManger = NetworkManager(session: urlSession)
        let queryItems = OpenMarketRequest().createQuery(of: pageNumber, with: itemPerPage)
        let request = OpenMarketRequest().requestProductList(queryItems: queryItems)
        
        networkManger.getProductInquiry(request: request) { result in
            switch result {
            case .success(let data):
                guard let productList = try? JSONDecoder().decode(MarketInformation.self, from: data) else { return }
                print(productList)
            case .failure(let error):
                print(error)
            }
        }
    }
}
