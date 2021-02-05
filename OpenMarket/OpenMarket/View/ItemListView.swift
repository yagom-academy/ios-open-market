//
//  ItemListView.swift
//  OpenMarket
//
//  Created by Yeon on 2021/02/01.
//

import Foundation
import UIKit

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.itemArray.count
        }
        else if section == 1 && isPaging && hasNextPage {
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell else {
                return UITableViewCell()
            }
            guard let item = itemArray[indexPath.row] else {
                return cell
            }
            cell.setUpView(with: item)
            
            if let imageURL = item.thumbnails.first {
                DispatchQueue.main.async {
                    if let index: IndexPath = tableView.indexPath(for: cell){
                        if index.item == indexPath.item {
                            cell.itemImageView.setImageFromServer(with: imageURL)
                        }
                    }
                }
            }
            return cell
        }
        else {
            guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? LoadingCell else {
                return UITableViewCell()
            }
            loadingCell.start()
            return loadingCell
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
