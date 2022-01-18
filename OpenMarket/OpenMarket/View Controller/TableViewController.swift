//
//  TableViewController.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/13.

import UIKit

@available(iOS 14.0, *)
class TableViewController: UITableViewController {
    @IBOutlet var productListTableView: UITableView!
    var productListData: ProductList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.image = UIImage(systemName: "")
        contentConfig.text = ""

        cell.contentConfiguration = contentConfig
        
        return cell
    }
    
    
}
