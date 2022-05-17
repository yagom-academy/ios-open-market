//
//  ProductListViewController.swift
//  Created by Lingo, Quokka
// 

import UIKit

final class ProductListViewController: UIViewController {
  private let networkService = APINetworkService(urlSession: URLSession.shared)
  private var productList = [Product]()

  private let segmentControl: UISegmentedControl = {
    let segment = UISegmentedControl(items: ["LIST", "GRID"])
    segment.selectedSegmentIndex = .zero
    return segment
  }()
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height / 10)
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
  }
  
  private func loadProductListData(page: Int, itemPerPage: Int) {
    self.networkService.fetchProductAll(pageNumber: page, itemsPerPage: itemPerPage) { result in
      guard let productList = try? result.get() else { return }
      self.productList = productList
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
