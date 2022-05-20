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
  
  private lazy var collectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: applyLayout(by: .list))
  private let urlProvider = ApiProvider<ProductsList>()
  private var pages: [Page] = [] {
    didSet {
      DispatchQueue.main.async {
        self.applySnapshot()
      }
    }
  }
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
    configureCollectionView()
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
  
  private func configureCollectionView() {
    self.view.addSubview(collectionView)
    self.view.backgroundColor = .white
    let safeArea = self.view.safeAreaLayoutGuide
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      collectionView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
      collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
    
    collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
    collectionView.register(GridCell.self, forCellWithReuseIdentifier: GridCell.identifier)
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
      collectionView.collectionViewLayout = applyLayout(by: .list)
    case Layout.grid.rawValue:
      collectionView.collectionViewLayout = applyLayout(by: .grid)
    default:
      return
    }
    collectionView.reloadData()
  }
  
  private func applyLayout(by layoutType: Layout) -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    layout.minimumLineSpacing = 8
    layout.minimumInteritemSpacing = 13
    
    switch layoutType {
    case .list:
      layout.itemSize = CGSize(
        width: self.view.bounds.width - (layout.sectionInset.left + layout.sectionInset.right),
        height: self.view.bounds.height/Constant.listCellCountPerColumn
      )
    case .grid:
      layout.itemSize = CGSize(
        width:
          self.view
          .bounds
          .width/Constant.cellCountPerRow - layout.minimumInteritemSpacing,
        height:
          self.view
          .bounds
          .height/Constant.gridCellCountPerColumn - layout.minimumInteritemSpacing
      )
    }
    return layout
  }
}

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
