//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // API 사용방법
        OpenMarketAPIClient().requestMarketItem(id: 63) { result in
            switch result {
            case .success(let marketItem):
                print("--- response of requestMarketItem ---")
                print("id: \(marketItem.id)")
                print("title: \(marketItem.title!)")
                print("price: \(marketItem.priceWithCurrency)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        OpenMarketAPIClient().requestMarketPage(pageNumber: 1) { result in
            switch result {
            case .success(let marketPage):
                print("--- response of requestMarketPage ---")
                for i in 0...2 {
                    print("pageNumber: \(marketPage.pageNumber)")
                    print("\(marketPage.marketItems[i].id): \(marketPage.marketItems[i].title!)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        let dummyImages = [Data(), Data(), Data()]
        let postMarketItem = PostMarketItem(title: "Jacob's Mac", descriptions: "제이콥의 맥북프로 16인치", price: 2500000, currency: "KRW", stock: 1, discountedPrice: 50000, images: dummyImages, password: "1234")
        OpenMarketAPIClient().registerMarketItme(postMarketItem) { result in
            switch result {
            case .success(let marketItem):
                print("--- response of registerMarketItem ---")
                print("id: \(marketItem.id)")
                print("title: \(marketItem.title!)")
                print("discription: \(marketItem.descriptions!)")
                print("price: \(marketItem.priceWithCurrency)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

