//
//  ViewController+TableView.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/26.
//

import UIKit

// MARK: Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.height / 11
    }
}

// MARK: Data Source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList?.productsInPage.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCell(withIdentifier: "TableViewCell")
        
        guard let typeCastedCell = cell as? TableViewCell else {
            return cell!
        }
        
        guard let productList = productList else {
            return typeCastedCell
        }
        
        typeCastedCell.updateCellContent(withData: productList.productsInPage[indexPath.item])
        
        return typeCastedCell
    }
}
