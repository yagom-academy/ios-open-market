//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

final class DetailViewController: UIViewController {
  private lazy var detailView = DetailView()
  private let detailAPIProvider = HttpProvider()
  private var product: DetailProduct?
  private var pageId: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureDetailView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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
      guard let data = try? data.get() else {
        return
      }
      guard let selectedProduct = try? JSONDecoder().decode(DetailProduct.self, from: data)
      else {
        return
      }
      
      self.product = selectedProduct
      DispatchQueue.main.async {
        self.configureNavigationBar()
        self.detailView.setUpDetailInformation(of: self.product)
      }
    }
  }
  
  private func configureDetailView() {
    let safeArea = self.view.safeAreaLayoutGuide
    self.view.addSubview(detailView)
    self.view.backgroundColor = .white
    NSLayoutConstraint.activate([
      detailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
      detailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
      detailView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
      detailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
  }
  
  private func configureNavigationBar() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                             target: self,
                                                             action: #selector(presentActionSheet))
    self.navigationItem.title = self.product?.name
    
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
  }
  
  @objc private func presentActionSheet() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let editAction = UIAlertAction(title: "수정", style: UIAlertAction.Style.default) { [weak self] (_) in
      self?.presentEditingView()
    }
    let deleteAction = UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive) { [weak self] (_) in
      self?.presentPasswordInputAlert()
    }
    let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel)
    
    alert.addAction(editAction)
    alert.addAction(deleteAction)
    alert.addAction(cancelAction)
    present(alert, animated: true)
  }
  
  private func presentEditingView() {
    let editingViewController = EditingViewController()
    let navigationController = UINavigationController(rootViewController: editingViewController)
    navigationController.modalPresentationStyle = .fullScreen
    editingViewController.receiveImformation(for: self.product)
    present(navigationController, animated: true, completion: nil)
  }
  
  private func presentPasswordInputAlert() {
    let alert = UIAlertController(title: "패스워드를 입력해주세요.", message: nil, preferredStyle: .alert)
    alert.addTextField { textField in
      textField.placeholder = "password 입력"
      textField.returnKeyType = .continue
      textField.isSecureTextEntry = true
    }
    
    let continueAction = UIAlertAction(title: "계속", style: .default) { (_) in
      guard let passwordText = alert.textFields?.first?.text else {
        return
      }
      self.checkSecret(passwordText) { text in
        print(text) // delete에 넣어주면된다.
      }
    }
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    
    alert.addAction(cancelAction)
    alert.addAction(continueAction)
    
    present(alert, animated: true)
  }
  
  private func checkSecret(_ inputPassword: String?, completionHandler: @escaping (String) -> Void) {
    guard let pageId = self.pageId else {
      return
    }
    guard let inputPassword = inputPassword else {
      return
    }
    self.detailAPIProvider.serachSecret(.searchingSecret(productId: pageId), Secret(secret: inputPassword)) { result in
      switch result {
      case .success(let data):
        guard let reponseSecret = try? JSONDecoder().decode(String.self, from: data) else {
          return
        }
        completionHandler(reponseSecret)
      case .failure(let error):
        print(error)
      }
    }
  }
}

