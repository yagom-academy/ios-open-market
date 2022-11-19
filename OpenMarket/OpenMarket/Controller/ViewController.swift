//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    var networkCommunication = NetworkCommunication()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getResponseAboutHealChecker()
        getProductsListData()
        getProductDetailData()
    }
    
    private func getResponseAboutHealChecker() {
        networkCommunication.requestHealthChecker(url: "https://openmarket.yagom-academy.kr/healthChecker") { response in
            switch response {
            case .success(let response):
                print("코드\(response.statusCode): 연결완료")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getProductsListData() {
        networkCommunication.requestProductsInformation(
            url: "https://openmarket.yagom-academy.kr/api/products?page_no=1&items_per_page=100",
            type: SearchListProducts.self) { data in
                switch data {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    private func getProductDetailData() {
        networkCommunication.requestProductsInformation(
            url: "https://openmarket.yagom-academy.kr/api/products/32",
            type: DetailProduct.self) { data in
                switch data {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
