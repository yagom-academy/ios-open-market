//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
  enum Section {
    case main
  }
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Page>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Page>
  
  private let urlProvider = ApiProvider<ProductsList>()
  private var pages: [Page] = [] {
    didSet {
      DispatchQueue.main.async {
        self.applySnapshot()
      }
    }
  }
  
  private lazy var collectionView = CollectionView()
  private lazy var dataSource = makeDataSource()
  private var currentPageNumber = 1
  private var productsList:ProductsList?
  
  private lazy var segmentedControl: UISegmentedControl = {
    let segment = UISegmentedControl(items: [Layout.list.string, Layout.grid.string])
    segment.selectedSegmentIndex = Layout.list.rawValue
    segment.addTarget(self,
                      action: #selector(changeCollectionViewLayout(_:)),
                      for: .valueChanged)
    return segment
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchPages()
    configureView()
    configureNavigationBar()
    applySnapshot(animatingDifferences: false)
    collectionView.prefetchDataSource = self
  }
  
  private func fetchPages() {
    urlProvider.get(.productList(pageNumber: currentPageNumber, itemsPerPage: 20)) { data in
      guard let products = try? data.get() else {
        return
      }
      self.productsList = products
      self.pages += products.pages
    }
  }
  
  private func configureView() {
    self.view.addSubview(collectionView)
    self.view.backgroundColor = .white
    collectionView.configureCollectionView()
  }
  
  private func configureNavigationBar() {
    navigationController?.navigationBar.backgroundColor = .lightGray
    navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
    navigationItem.titleView = segmentedControl
    navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add,
                                              target: .none,
                                              action: .none)
  }
  
  @objc private func changeCollectionViewLayout(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case Layout.list.rawValue:
      collectionView.currentLayout = .list
    case Layout.grid.rawValue:
      collectionView.currentLayout = .grid
    default:
      return
    }
  }
}
// MARK: - DataSource
extension MainViewController {
  private func makeDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: collectionView,
      cellProvider: {(collectionView, indexPath, page) -> UICollectionViewCell? in
        
        switch self.segmentedControl.selectedSegmentIndex {
        case Layout.list.rawValue:
          guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ListCell.identifier,
            for: indexPath
          ) as? ListCell
          else {
            return nil
          }
          DispatchQueue.main.async {
            if collectionView.indexPath(for: cell) == indexPath {
              cell.setUpListCell(page: page)
            }
          }
          return cell
          
        case Layout.grid.rawValue:
          guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GridCell.identifier,
            for: indexPath
          ) as? GridCell
          else {
            return nil
          }
          DispatchQueue.main.async {
            if collectionView.indexPath(for: cell) == indexPath {
              cell.setUpGridCell(page: page)
            }
          }
          return cell
          
        default:
          return nil
        }
      })
    return dataSource
  }
  
  private func applySnapshot(animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(pages)
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
}
// MARK: - UICollectionViewDataSourcePrefetching
extension MainViewController: UICollectionViewDataSourcePrefetching {
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    guard productsList?.hasNext == true else {
      return
    }
    
    if indexPaths.last?.row == pages.count - 1 {
      currentPageNumber += 1
      fetchPages()
    }
  }
}
