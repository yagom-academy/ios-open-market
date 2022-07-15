//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ItemListPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private var itemListPage: ItemListPage?
    
    private let queryString = QueryCharacter.questionMark + QueryKey.pageNumber + QueryValue.pageNumber + QueryCharacter.ampersand + QueryKey.itemsPerPage + QueryValue.itemsPerPage
    
    private lazy var url = Path.products + queryString
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.performRequestToAPI(with: url) { (result: Result<Data, APIError>) in
            self.fetchParsedData(basedOn: result)
        }
    }
}

// MARK: - Private Actions

private extension ItemListPageViewController {
    func fetchParsedData(basedOn result: Result<Data, APIError>) {
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
    
    func fetchDataForItemListPage() {
        let data = DataManager.makeDataFrom(fileName: "products")
        
        guard let parsedData = DataManager.parse(data, into: itemListPage) else {
            return
        }
        
        itemListPage = parsedData
    }
}

// MARK: - Private Enums

private extension ItemListPageViewController {
    enum QueryValue {
        static var pageNumber = "1"
        static var itemsPerPage = "10"
    }
    
    enum QueryKey {
        static var pageNumber = "page_no="
        static var itemsPerPage = "items_per_page="
    }
    
    enum Path {
        static var products = "/api/products"
    }
    
    enum QueryCharacter {
        static var questionMark = "?"
        static var ampersand = "&"
    }
}
