//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UITableViewController {
    
    private var currentPage: UInt = 1
    private var list = [ListedItem]()
    @IBOutlet var itemListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemListTableView.dataSource = self
        self.itemListTableView.delegate = self
        
        let networkManager = NetworkManager()
        networkManager.fetchItemList(page: self.currentPage) { result in
            switch result {
            case .success(let model):
                let fetchedItemList = ItemList(page: self.currentPage, itemList: model.itemList)
                let listedItem = fetchedItemList.itemList
                self.list.append(contentsOf: listedItem)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.errorDescription, preferredStyle: UIAlertController.Style.alert)
                self.present(alert, animated: false)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.list.count != 0 {
            return self.list.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = itemListTableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
    
        itemCell.itemName?.text = self.list[indexPath.row].title
        itemCell.price?.text = "\(self.list[indexPath.row].price)"
        itemCell.stockAmount?.text = "\(self.list[indexPath.row].stock)"
        
        DispatchQueue.main.async(execute: {
          itemCell.thumbnail.image = self.getThumbnailImage(indexPath.row)
        })
        
        return itemCell
    }
    
    private func getThumbnailImage(_ index: Int) -> UIImage {
        let listedItem = self.list[index]
        let url: URL! = URL(string: listedItem.thumbnails[0])
        let imageData = try! Data(contentsOf: url)
        return UIImage(data:imageData)!
    }
}

// MARK: - UITableViewDelegate
extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
