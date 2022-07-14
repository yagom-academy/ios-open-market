//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ItemListPageViewController: UIViewController {
    var itemListPage: ItemListPage?
    let request = "products?page_no=1&items_per_page=10"
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        DataManager.performRequestToAPI(with: request) { data in
            guard let parsedData = DataManager.parse(data, into: self.itemListPage) else {
                return
            }
            
            self.itemListPage = parsedData
        }
    }

   private func fetchDataForItemListPage() {
       let data = DataManager.makeDataFrom(fileName: "products")
       
       guard let parsedData = DataManager.parse(data, into: itemListPage) else {
           return
       }

       itemListPage = parsedData
   }
}
