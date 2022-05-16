//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
  private lazy var collectionView = UICollectionView(frame: .zero,
                                             collectionViewLayout: configureListLayout())
  private let urlProvider = URLSessionProvider<ProductsList>(path: "/api/products",
                                                     parameters: ["page_no":"1",
                                                                  "items_per_page": "20"])
  private lazy var segmentedControl: UISegmentedControl = {
    let segment = UISegmentedControl(items: ["LIST", "GRID"])
    segment.selectedSegmentIndex = 0
    segment.addTarget(self, action: #selector(changeCollectionViewLayout(_:)), for: .valueChanged)
    
    return segment
  }()
  
  private func configureNavigationItems() {
    navigationItem.titleView = segmentedControl
    navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add,
                                              target: .none,
                                              action: .none)
  }
  
  @objc private func changeCollectionViewLayout(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      collectionView.collectionViewLayout = configureListLayout()
    case 1:
      collectionView.collectionViewLayout = configureGridLayout()
    default:
      return
    }
    collectionView.reloadData()
  }


  private var pages: [Page] = [] {
    didSet {
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchPages()
    configureCollectionView()
    collectionView.collectionViewLayout = configureListLayout()
    configureNavigationItems()
  }
  
  
  private func configureCollectionView() {
    self.view.addSubview(collectionView)
    collectionView.frame = self.view.safeAreaLayoutGuide.layoutFrame
    self.collectionView.register(ListCell.self, forCellWithReuseIdentifier: "ListCell")
    self.collectionView.register(GridCell.self, forCellWithReuseIdentifier: "GridCell")
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
  
  private func configureGridLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    layout.itemSize = CGSize(width: self.view.bounds.width/2 - 15,
                             height: self.view.bounds.height/3)
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
    if segmentedControl.selectedSegmentIndex == 0 {
      let id = String(describing: ListCell.self)
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id,
                                                          for: indexPath) as? ListCell else {
        return UICollectionViewCell()
      }
      cell.setUpListCell(page: self.pages[indexPath.row])
      return cell
    } else {
      let id = String(describing: GridCell.self)
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id,
                                                          for: indexPath) as? GridCell else {
        return UICollectionViewCell()
      }
      cell.setUpListCell(page: self.pages[indexPath.row])
      return cell
    }
  }
}

