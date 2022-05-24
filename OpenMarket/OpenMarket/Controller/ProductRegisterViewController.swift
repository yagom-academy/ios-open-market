//
//  ProductRegisterViewController.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/24.
//

import UIKit

final class ProductRegisterViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.configureNavigationItem()
  }
  
  private func configureNavigationItem() {
    self.title = "상품등록"
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .cancel,
      target: self,
      action: #selector(closeButtonDidTap))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(closeButtonDidTap))
  }
  
  private func configureUI() {
    self.view.backgroundColor = .systemBackground
  }
  
  @objc private func closeButtonDidTap() {
    self.dismiss(animated: true)
  }
}
