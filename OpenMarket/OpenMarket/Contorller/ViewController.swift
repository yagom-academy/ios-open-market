//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let networkManager = NetworkManager()
    let parsingManager = ParsingManager()
    

    override func viewDidLoad() {
        let postItem = generatePostItem()
        let deleteItem = generateDeleteItem()
        let deleteData = parsingManager.createDataBody(model: deleteItem)
        let postData = parsingManager.createDataBody(model: postItem)
        networkManager.request(requsetType: RequestType.post, url: "https://camp-open-market-2.herokuapp.com/item", model: postData) { (result) in
            print(result)
        }
        networkManager.request(requsetType: RequestType.post, url: "https://camp-open-market-2.herokuapp.com/item/1", model: deleteData) { (result) in
            print(result)
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func generatePostItem() -> PostItem {
        let title = "MacBook Pro"
        let descriptions = "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다."
        let price = 1690000
        let currency = "KRW"
        let stock = 1000000000000
        let images: [Data] = [
            UIImage(named: "MackBookImage_0")!.jpegData(compressionQuality: 1)!,
            UIImage(named: "MackBookImage_1")!.jpegData(compressionQuality: 1)!
        ]
        let password = "asdf"
        
        let dummyPostItem = PostItem(title: title,
                                 descriptions: descriptions,
                                 price: price,
                                 currency: currency, stock: stock, discountedPrice: nil,
                                 images: images, password: password)
        return dummyPostItem
    }
    
    func generateDeleteItem() -> DeleteItem {
        let password = "asdf"
        let dummyDeleteItem = DeleteItem(password: password)
        return dummyDeleteItem
    }
}

