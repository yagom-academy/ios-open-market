//
//  ViewController.swift
//  Created by Lingo, Quokka
// 

import UIKit

final class ViewController: UIViewController {
  private let networkService = APINetworkService(urlSession: URLSession.shared)
  private var productList = [Product]()

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  private func loadProductListData(page: Int, itemPerPage: Int) {
    self.networkService.fetchProductAll(pageNumber: page, itemsPerPage: itemPerPage) { result in
      guard let productList = try? result.get() else { return }
      self.productList = productList
    }
  }
}
