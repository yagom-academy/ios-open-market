//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    var networkCommunication = NetworkCommunication()

    var searchListProducts: SearchListProducts?
    var detailProduct: DetailProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getResponseAboutHealChecker()
        getProductsListData()
        getProductDetailData(productNumber: "31")
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
    
    private func getProductsListData(pageNumber: String = "1", itemPerPage: String = "100") {
        networkCommunication.requestProductsInformation(
            url: "https://openmarket.yagom-academy.kr/api/products?page_no=\(pageNumber)&items_per_page=\(itemPerPage)",
            type: SearchListProducts.self) { data in
                switch data {
                case .success(let data):
                    guard let data = data as? SearchListProducts else { return }
                    self.searchListProducts = data
                    print(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    private func getProductDetailData(productNumber: String) {
        networkCommunication.requestProductsInformation(
            url: "https://openmarket.yagom-academy.kr/api/products/" + productNumber,
            type: DetailProduct.self) { data in
                switch data {
                case .success(let data):
                    guard let data = data as? DetailProduct else { return }
                    self.detailProduct = data
                    print(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
