//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return self.pages.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let id = String(describing: ListCell.self)
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id,
                                                        for: indexPath) as? ListCell else {
      return UICollectionViewCell()
    }
    cell.setUpListCell(page: self.pages[indexPath.row])
    return cell
  }
}

