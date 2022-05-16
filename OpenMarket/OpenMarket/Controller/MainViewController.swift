//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
  lazy var collectionView = UICollectionView(frame: .zero,
                                             collectionViewLayout: configureListLayout())
  let urlProvider = URLSessionProvider<ProductsList>(path: "/api/products",
                                                     parameters: ["page_no":"1",
                                                                  "items_per_page": "20"])
  private var pages: [Page] = [] {
    didSet {
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  
  
  private func configureCollectionView() {
    self.view.addSubview(collectionView)
    collectionView.frame = self.view.safeAreaLayoutGuide.layoutFrame
    self.collectionView.register(ListCell.self, forCellWithReuseIdentifier: "ListCell")
    self.collectionView.dataSource = self
  }
  
  private func configureListLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    layout.itemSize = CGSize(width: self.view.bounds.width,
                             height: self.view.bounds.height/14)
    return layout
  }
  
  private func fetchPages() {
    urlProvider.get { data in
      guard let products = try? data.get() else {
        return
      }
      self.pages = products.pages
    }
  }
}

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

