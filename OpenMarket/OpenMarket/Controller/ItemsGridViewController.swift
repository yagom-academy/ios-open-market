//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ItemsGridViewController: UIViewController {
    private let manager = NetworkManager(session: MockURLSession())
    private var items: [Page.Item]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeItems()
    }
    
    private func initializeItems() {
        guard let url = URL(string: MockURL.mockItems.description) else { return }
        
        manager.fetchData(url: url) { (result: Result<Page, Error>) in
            switch result {
            case .success(let decodedData):
                self.items = decodedData.items
            case .failure(let error):
                print(error)
            }
        }
    }
}
