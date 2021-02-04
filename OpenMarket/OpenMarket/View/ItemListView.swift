//
//  ItemListView.swift
//  OpenMarket
//
//  Created by Yeon on 2021/02/01.
//

import Foundation
import UIKit

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let itemListCount = self.itemList?.items.count else {
            return 0
        }
        return itemListCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell else {
            return UITableViewCell()
        }
        guard let list = itemList else {
            return cell
        }
        cell.setUpView(with: list.items[indexPath.row])
        
        if let imageURL = list.items[indexPath.row].thumbnails.first {
            ItemManager.shared.loadItemImage(with: imageURL) { result in
                switch result {
                case .success(let data):
                    guard let image = data else {
                        return self.errorHandling(error: .failGetData)
                    }
                    DispatchQueue.main.async {
                        if let index: IndexPath = tableView.indexPath(for: cell){
                            if index.row == indexPath.row {
                                cell.itemImageView.image = UIImage(data: image)
                            }
                        }
                    }
                case .failure(let error):
                    self.errorHandling(error: error)
                }
            }
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
