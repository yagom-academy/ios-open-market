//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    var itemList: ItemList?
    
    override func viewDidLoad() {
        let item = ItemListFetcher()
        do {
            try item.fetchItemList()
            self.itemList = item.itemList
        } catch {
            // viewDidLoad가 non-throw라서 에러 핸들링이 안되는 부분. 무엇을 해야할지 고민
        }
    }
}

