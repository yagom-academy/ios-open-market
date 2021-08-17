//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let networkManager = NetworkManager()
    let parsingManager = ParsingManager()
    
    let images: [Photo] = [
        Photo.init(withImage: UIImage(named: "MackBookImage_0")!)!,
        Photo.init(withImage: UIImage(named: "MackBookImage_1")!)!
    ]
    

    override func viewDidLoad() {
        let postItem = generatePostItem()
        networkManager.request(requsetType: RequestType.post, url: "https://camp-open-market-2.herokuapp.com/item", model: postItem) { (result) in
            print(result)
        }
        
        super.viewDidLoad()
    }
    
    func generatePostItem() -> PostItem {
        let title = "MacBook Pro"
        let descriptions = "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다."
        let price = 1690000
        let currency = "KRW"
        let stock = 1000000000000
        let images: [Photo] = [
            Photo.init(withImage: UIImage(named: "MackBookImage_0")!)!,
            Photo.init(withImage: UIImage(named: "MackBookImage_1")!)!
        ]
        let password = "asdf"
        
        let dummyPostItem = PostItem(title: title,
                                 descriptions: descriptions,
                                 price: price,
                                 currency: currency, stock: stock, discountedPrice: nil,
                                 mediaFile: images, password: password)
        return dummyPostItem
    }
}

