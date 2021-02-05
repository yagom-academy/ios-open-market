//
//  TableViewController.swift
//  OpenMarket
//
//  Created by sole on 2021/02/04.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let mainViewController = self.parent as? MainViewController else {
            return 0
        }
        return mainViewController.itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? ListCell,
              let mainViewController = self.parent as? MainViewController,
              let item = mainViewController.getItem(indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.tag = indexPath.row
        cell.setContents(with: item)
        return cell
    }
}

extension TableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let row = indexPaths.last?.row,
              let mainViewController = self.parent as? MainViewController else {
            return
        }
        if row >= mainViewController.itemsCount - 2 {
            page += 1
            mainViewController.requestItems(page: page) {
                DispatchQueue.main.async {
                    tableView.reloadData() // TODO: 코드 Depth 줄이기.
                }
            }
        }
    }
}
