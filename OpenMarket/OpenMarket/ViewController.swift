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
                print("--- result of requestMarketItem ---")
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
                print("--- result of requestMarketPage ---")
                for i in 0...2 {
                    print("pageNumber: \(marketPage.pageNumber)")
                    print("\(marketPage.marketItems[i].id): \(marketPage.marketItems[i].title!)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

