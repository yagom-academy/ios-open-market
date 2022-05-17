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
  enum layoutType {
    case list
    case grid
    
    var string: String {
      switch self {
      case .list:
        return "LIST"
      case .grid:
        return "GRID"
      }
    }
  }
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Page>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Page>
  private lazy var dataSource = makeDataSource()
  private lazy var collectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: configureListLayout())
  private let urlProvider = URLSessionProvider<ProductsList>(path: "/api/products",
                                                             parameters: ["page_no":"1",
                                                                          "items_per_page": "20"])
  private var pages: [Page] = [] {
    didSet {
      DispatchQueue.main.async {
        self.applySnapshot()
      }
    }
  }
  
  private lazy var segmentedControl: UISegmentedControl = {
    let segment = UISegmentedControl(items: [layoutType.list.string, layoutType.grid.string])
    segment.selectedSegmentIndex = 0
    segment.addTarget(self, action: #selector(changeCollectionViewLayout(_:)), for: .valueChanged)
    return segment
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchPages()
    configureCollectionView()
    configureNavigationBar()
    applySnapshot(animatingDifferences: false)
    collectionView.dataSource = self.dataSource
  }
  
  private func fetchPages() {
    urlProvider.get { data in
      guard let products = try? data.get() else {
        return
      }
      self.pages = products.pages
    }
  }
  
  private func configureCollectionView() {
    self.view.addSubview(collectionView)
    let safeArea = self.view.safeAreaLayoutGuide
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([collectionView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
                                 collectionView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
                                 collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                                 collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
                                ])
    self.collectionView.register(ListCell.self, forCellWithReuseIdentifier: "ListCell")
    self.collectionView.register(GridCell.self, forCellWithReuseIdentifier: "GridCell")
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
    case 0:
      collectionView.collectionViewLayout = configureListLayout()
    case 1:
      collectionView.collectionViewLayout = configureGridLayout()
    default:
      return
    }
    collectionView.reloadData()
  }
  
  private func configureListLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    layout.itemSize = CGSize(width: self.view.bounds.width,
                             height: self.view.bounds.height/14)
    return layout
  }
  
  private func configureGridLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    layout.itemSize = CGSize(width: self.view.bounds.width/2 - 15,
                             height: self.view.bounds.height/3)
    return layout
  }
}

extension MainViewController {
  private func makeDataSource() -> DataSource {
    let dataSource = DataSource(collectionView: collectionView, cellProvider: {
      (collectionView, indexPath, page) ->
      UICollectionViewCell? in
      if self.segmentedControl.selectedSegmentIndex == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell",
                                                      for: indexPath) as? ListCell
        cell?.setUpListCell(page: self.pages[indexPath.row])
        return cell
      } else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell",
                                                            for: indexPath) as? GridCell
        cell?.setUpGridCell(page: self.pages[indexPath.row])
        return cell
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
