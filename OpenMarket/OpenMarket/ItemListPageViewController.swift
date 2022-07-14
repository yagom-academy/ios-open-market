//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ItemListPageViewController: UIViewController {
    var itemListPage: ItemListPage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDataForItemListPage()
    }

   private func fetchDataForItemListPage() {
       guard let parsedData = DataManager.parse("products", into: itemListPage) else {
           return
       }
       
       itemListPage = parsedData
   }
}

