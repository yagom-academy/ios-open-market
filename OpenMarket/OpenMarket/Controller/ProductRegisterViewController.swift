//
//  ProductRegisterViewController.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/24.
//

import UIKit

final class ProductRegisterViewController: UIViewController {
  private let containerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let imageScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  private let imageStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    return stackView
  }()
  
  private let textStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    return stackView
  }()
  
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
    self.view.addSubview(containerStackView)
    self.containerStackView.addArrangedSubview(imageScrollView)
    self.containerStackView.addArrangedSubview(textStackView)
    self.imageScrollView.addSubview(imageStackView)
    
    NSLayoutConstraint.activate([
      containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      
      imageScrollView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.2),
      
      imageStackView.topAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.topAnchor),
      imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.bottomAnchor),
      imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.leadingAnchor),
      imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.trailingAnchor),
      imageStackView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor)
    ])
  }
  
  @objc private func closeButtonDidTap() {
    self.dismiss(animated: true)
  }
}
