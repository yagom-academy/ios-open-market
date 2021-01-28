//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    let productListTableView = UITableView()
    let testProductList = ["a","b","c"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productListTableView.delegate = self
        productListTableView.dataSource = self
        productListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(productListTableView)
        
        setUpProductListView()
    }
    
    private func setUpProductListView() {
        productListTableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: productListTableView,
             attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top,
             multiplier: 1.0, constant: 0))
           self.view.addConstraint(NSLayoutConstraint(item: productListTableView,
             attribute: .bottom, relatedBy: .equal, toItem: self.view,
             attribute: .bottom, multiplier: 1.0, constant: 0))
           self.view.addConstraint(NSLayoutConstraint(item: productListTableView,
             attribute: .leading, relatedBy: .equal, toItem: self.view,
             attribute: .leading, multiplier: 1.0, constant: 0))
           self.view.addConstraint(NSLayoutConstraint(item: productListTableView,
             attribute: .trailing, relatedBy: .equal, toItem: self.view,
             attribute: .trailing, multiplier: 1.0, constant: 0))
    }
}
extension ViewController: UITableViewDelegate {
    
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = testProductList[indexPath.row]
        return cell
    }
}
