//
//  MainViewController.swift
//  OpenMarket
//
//  Created by sole on 2021/02/04.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var collectionView: UIView!
    var items: [Int: [Item]] = [:]
    var itemsCount: Int {
        return items.reduce(0) { currentCount, next in
            currentCount + next.value.count
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let list = tableView.subviews.first?.subviews.first as? UITableView {
            requestItems(page: 1) {
                DispatchQueue.main.async {
                    list.reloadData() // TODO: 코드 Depth 줄이기.
                }
            }
        }
    }
    
    @IBAction func switchView(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            tableView.isHidden = false
            collectionView.isHidden = true
        } else {
            tableView.isHidden = true
            collectionView.isHidden = false
        }
    }
}

extension MainViewController {
    func requestItems(page: Int, _ completionHandler: @escaping () -> Void) {
        guard self.items[page] == nil else {
            return
        }
        OpenMarketAPI.request(.loadItemList(page: page)) { (result: Result<ItemsToGet, Error>) in
            switch result {
            case .success(let data):
                self.items.updateValue(data.items, forKey: data.page)
                completionHandler()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getItem(_ row: Int) -> Item? {
        let page = row / 20 + 1
        let n = row % 20
        if let itemsOfPage = items[page] {
            return itemsOfPage[n]
        }
        return nil
    }
}
