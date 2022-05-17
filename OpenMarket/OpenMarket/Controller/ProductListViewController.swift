//
//  ProductListViewController.swift
//  Created by Lingo, Quokka
// 

import UIKit

final class ProductListViewController: UIViewController {
  private let networkService = APINetworkService(urlSession: URLSession.shared)
  private var productList = [Product]() {
    didSet {
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }

  private lazy var segmentControl: UISegmentedControl = {
    let segment = UISegmentedControl(items: ["LIST", "GRID"])
    segment.setWidth(80, forSegmentAt: 0)
    segment.setWidth(80, forSegmentAt: 1)
    segment.selectedSegmentIndex = .zero
    segment.addTarget(self, action: #selector(changeLayout(_:)), for: .valueChanged)
    return segment
  }()
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height / 15)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .systemBackground
    collectionView.dataSource = self
    collectionView.register(
      ProductListCollectionViewCell.self,
      forCellWithReuseIdentifier: ProductListCollectionViewCell.identifier)
    collectionView.register(
      ProductGridCollectionViewCell.self,
      forCellWithReuseIdentifier: ProductGridCollectionViewCell.identifier)
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.loadProductListData(page: 1, itemPerPage: 10)
  }
  
  private func loadProductListData(page: Int, itemPerPage: Int) {
    self.networkService.fetchProductAll(pageNumber: page, itemsPerPage: itemPerPage) { result in
      guard let productList = try? result.get() else { return }
      self.productList = productList
    }
  }
  
  @objc func changeLayout(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      let layout = UICollectionViewFlowLayout()
      layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height / 15)
      self.collectionView.reloadData()
      self.collectionView.collectionViewLayout = layout
    case 1:
      let layout = UICollectionViewFlowLayout()
      layout.itemSize = CGSize(width: view.frame.width / 2 - 20, height: view.frame.height / 3)
      layout.sectionInset = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
      self.collectionView.reloadData()
      self.collectionView.collectionViewLayout = layout
    default:
      break
    }
  }
  
  private func configureUI() {
    self.view.backgroundColor = .systemBackground
    self.navigationItem.titleView = segmentControl
    self.view.addSubview(collectionView)
    self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
    ])
  }
}

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
    switch segmentControl.selectedSegmentIndex {
    case 0:
      guard let listCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ProductListCollectionViewCell.identifier,
        for: indexPath) as? ProductListCollectionViewCell
      else { return ProductListCollectionViewCell() }
      
      listCell.setup(product: self.productList[indexPath.row])
      return listCell
    case 1:
      guard let gridCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ProductGridCollectionViewCell.identifier,
        for: indexPath) as? ProductGridCollectionViewCell
      else { return ProductGridCollectionViewCell() }
      
      gridCell.setup(product: self.productList[indexPath.row])
      return gridCell
    default:
      return UICollectionViewCell()
    }
  }
}
