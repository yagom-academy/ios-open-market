//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

class DetailViewController: UIViewController {
  private let detailAPIProvider = ApiProvider<DetailProduct>()
  private var product: DetailProduct?
  private var pageId: Int?

  override func viewDidLoad() {
    super.viewDidLoad()
    fetchDetailProductData()
  }
  
  func receiveInformation(for id: Int) {
    self.pageId = id
  }
  
  private func fetchDetailProductData() {
    guard let pageId = pageId else {
      return
    }
    detailAPIProvider.get(.editing(productId: pageId)) { data in
      guard let selectedProduct = try? data.get() else {
        return
      }
      self.product = selectedProduct
      DispatchQueue.main.async {
        self.configureNavigationBar()
      }
    }
  }
  
  private func configureNavigationBar() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                             target: self,
                                                             action: #selector(presentEditingView))
    self.navigationItem.title = self.product?.name
    
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
  }
  
  @objc private func presentEditingView() {
    let editingViewController = EditingViewController()
    let navigationController = UINavigationController(rootViewController: editingViewController)
    navigationController.modalPresentationStyle = .fullScreen
    editingViewController.receiveImformation(for: self.product)
    present(navigationController, animated: true, completion: nil)
  }
}

