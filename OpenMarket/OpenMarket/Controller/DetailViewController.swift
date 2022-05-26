//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

class DetailViewController: UIViewController {
  var delegate: Page?
  private var product: DetailProduct?
  let detailAPIProvider = ApiProvider<DetailProduct>()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.fetchDetailProductData()
  }
  
  private func configureNavigationBar() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                             target: self,
                                                             action: #selector(presentEditingView))
    self.navigationItem.title = product?.name
    
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
  }
  
  @objc private func presentEditingView() {
    let editingViewController = EditingViewController()
    let navigationController = UINavigationController(rootViewController: editingViewController)
    navigationController.modalPresentationStyle = .fullScreen
    editingViewController.delegate = product
    present(navigationController, animated: true, completion: nil)
  }
  
  private func fetchDetailProductData() {
    guard let page = delegate else {
      return
    }
    detailAPIProvider.get(.editing(productId: page.id)) { data in
      guard let selectedProduct = try? data.get() else {
        return
      }
      self.product = selectedProduct
      DispatchQueue.main.async {
        self.configureNavigationBar()
      }
    }
  }
}

