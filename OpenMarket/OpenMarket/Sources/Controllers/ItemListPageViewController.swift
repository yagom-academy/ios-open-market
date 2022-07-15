//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ItemListPageViewController: UIViewController {
    private enum QueryValue {
        static var pageNumber = "1"
        static var itemsPerPage = "10"
    }
    
    private enum QueryKey {
        static var pageNumber = "page_no="
        static var itemsPerPage = "items_per_page="
    }
    
    private enum Path {
        static var products = "/api/products"
    }
    
    private enum QueryCharacter {
        static var questionMark = "?"
        static var ampersand = "&"
    }
    
    private var itemListPage: ItemListPage?
    
    private let queryString = QueryCharacter.questionMark + QueryKey.pageNumber + QueryValue.pageNumber + QueryCharacter.ampersand + QueryKey.itemsPerPage + QueryValue.itemsPerPage
    
    private lazy var url = Path.products + queryString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.performRequestToAPI(with: url) { (result: Result<Data, APIError>) in
            self.fetchParsedData(basedOn: result)
        }
    }
    
    private func fetchParsedData(basedOn result: Result<Data, APIError>) {
        switch result {
        case .success(let data):
            guard let parsedData = DataManager.parse(data, into: self.itemListPage) else {
                return
            }
            
            self.itemListPage = parsedData
            
        case .failure(let error):
            print(error)
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
