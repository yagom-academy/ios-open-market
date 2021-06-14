//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UITableViewController {
    
    let test = ["1","2","3","4","5"]
    var itemList: ItemList?
    @IBOutlet var itemListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemListTableView.dataSource = self
        self.itemListTableView.delegate = self
    }
    // FIXME: - Error 핸들링 방법
    override func viewDidAppear(_ animated: Bool) {
        let networkManager = NetworkManager()
        networkManager.fetchItemList { result in
            switch result {
            case .success(let model):
                self.itemList = model
                return
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //FIXME: - 작동 시점
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let itemList = itemList {
            return itemList.itemList.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = itemListTableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        itemCell.itemName.text = test[indexPath.row]
        
        return itemCell
    }
}

// MARK: - UITableViewDelegate
extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
