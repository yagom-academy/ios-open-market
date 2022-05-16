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
  }
}
