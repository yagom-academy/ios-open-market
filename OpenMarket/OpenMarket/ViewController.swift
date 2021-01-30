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
        // API 상품목록 조회 기능 사용 예시
        OpenMarketAPIClient().getMarketPage(pageNumber: 1) { result in
            switch result {
            case .success(let marketPage):
                print("--- response of getMarketPage ---")
                for i in 0...2 {
                    print("pageNumber: \(marketPage.pageNumber)")
                    print("\(marketPage.marketItems[i].id): \(marketPage.marketItems[i].title!)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // API 상품 등록 기능 사용 예시
        let dummyImages = [Data(), Data(), Data()]
        let marketItemForPost = MarketItemForPost(title: "Jacob's Mac", descriptions: "제이콥의 맥북프로 16인치", price: 2500000, currency: "KRW", stock: 1, discountedPrice: 50000, images: dummyImages, password: "1234")
        OpenMarketAPIClient().postMarketIem(marketItemForPost) { result in
            switch result {
            case .success(let marketItem):
                print("--- response of postMarketItem ---")
                print("id: \(marketItem.id)")
                print("title: \(marketItem.title!)")
                print("discription: \(marketItem.descriptions!)")
                print("price: \(marketItem.priceWithCurrency)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // API 상품 조회 기능 사용 예시
        OpenMarketAPIClient().getMarketItem(id: 63) { result in
            switch result {
            case .success(let marketItem):
                print("--- response of getMarketItem ---")
                print("id: \(marketItem.id)")
                print("title: \(marketItem.title!)")
                print("price: \(marketItem.priceWithCurrency)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // API 상품 수정 기능 사용 예시
        let marketItemForPatch = MarketItemForPatch(title: "Jacob's Mac", descriptions: "가격 다운!", price: 1000000, currency: "KRW", stock: 1, discountedPrice: 50000, images: nil, password: "1234")
        OpenMarketAPIClient().patchMarketItem(id: 377, marketItemForPatch) { result in
            switch result {
            case .success(let marketItem):
                print("--- response of patchMarketItem ---")
                print("id: \(marketItem.id)")
                print("title: \(marketItem.title!)")
                print("discription: \(marketItem.descriptions!)")
                print("price: \(marketItem.priceWithCurrency)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // API 상품 삭제 기능 사용 예시
        let marketItemForDelete = MarketItemForDelete(id: 374, password: "1234")
        OpenMarketAPIClient().deleteMarketItem(id: 374, marketItemForDelete) { result in
            switch result {
            case .success(let marketItem):
                print("--- response of deleteMarketItem ---")
                print("id: \(marketItem.id)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

