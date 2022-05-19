//
//  ProductListViewController.swift
//  Created by Lingo, Quokka
// 

import UIKit

fileprivate enum SegmentIndex: Int {
  case list = 0
  case grid
}

final class ProductListViewController: UIViewController {
  private enum Constant {
    static let segmentWidth = 80.0
  }
  
  private let networkService = APINetworkService(urlSession: URLSession.shared)
  private var productList = [Product]() {
    didSet {
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  
  private lazy var addProductButton = UIBarButtonItem(
    barButtonSystemItem: .add,
    target: self,
    action: #selector(addButtonDidTap))

  private lazy var segmentControl: UISegmentedControl = {
    let segment = UISegmentedControl(items: ["LIST", "GRID"])
    segment.setWidth(Constant.segmentWidth, forSegmentAt: .zero)
    segment.setWidth(Constant.segmentWidth, forSegmentAt: 1)
    segment.selectedSegmentIndex = .zero
    segment.addTarget(self, action: #selector(segmentControlDidTap), for: .valueChanged)
    return segment
  }()
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height / 15)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .systemBackground
    collectionView.register(
      ProductListCollectionViewCell.self,
      forCellWithReuseIdentifier: ProductListCollectionViewCell.identifier)
    collectionView.register(
      ProductGridCollectionViewCell.self,
      forCellWithReuseIdentifier: ProductGridCollectionViewCell.identifier)
    return collectionView
  }()
  
  private let indicator = UIActivityIndicatorView(style: .large)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.collectionView.dataSource = self
    self.loadProductListData(page: 1, itemPerPage: 30)
  }
  
  private func loadProductListData(page: Int, itemPerPage: Int) {
    self.indicator.startAnimating()
    self.networkService.fetchProductAll(pageNumber: page, itemsPerPage: itemPerPage) { result in
      guard let productList = try? result.get() else { return }
      self.productList = productList
      DispatchQueue.main.async {
        self.indicator.stopAnimating()
      }
    }
  }
  
  @objc private func addButtonDidTap(_ sender: UIBarButtonItem) {}
}

// MARK: - UI

private extension ProductListViewController {
  @objc func segmentControlDidTap(_ sender: UISegmentedControl) {
    guard let segment = SegmentIndex(rawValue: segmentControl.selectedSegmentIndex)
    else { return }
    
    self.collectionView.reloadData()
    switch segment {
    case .list:
      self.configureListLayout()
    case .grid:
      self.configureGridLayout()
    }
  }
  
  func configureListLayout() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height / 15)
    self.collectionView.collectionViewLayout = layout
  }
  
  func configureGridLayout() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: view.frame.width / 2 - 20, height: view.frame.height / 3)
    layout.sectionInset = UIEdgeInsets(top: .zero, left: 10.0, bottom: .zero, right: 10.0)
    self.collectionView.collectionViewLayout = layout
  }
  
  func configureUI() {
    self.view.backgroundColor = .systemBackground
    self.navigationItem.rightBarButtonItem = addProductButton
    self.navigationItem.titleView = segmentControl
    self.view.addSubview(collectionView)
    self.view.addSubview(indicator)
    self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    self.indicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      indicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      indicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      indicator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      indicator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    ])
  }
}

// MARK: - DataSource

extension ProductListViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.productList.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let segment = SegmentIndex(rawValue: segmentControl.selectedSegmentIndex)
    else { return UICollectionViewCell() }
    
    switch segment {
    case .list:
      guard let listCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ProductListCollectionViewCell.identifier,
        for: indexPath) as? ProductListCollectionViewCell
      else { return ProductListCollectionViewCell() }
      
      listCell.setUp(product: self.productList[indexPath.row])
      return listCell
    case .grid:
      guard let gridCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ProductGridCollectionViewCell.identifier,
        for: indexPath) as? ProductGridCollectionViewCell
      else { return ProductGridCollectionViewCell() }
      
      gridCell.setUp(product: self.productList[indexPath.row])
      return gridCell
    }
  }
}
