//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

final class DetailViewController: UIViewController {
  private enum Constants {
    static let venderId: Int = 82
    static let editTitle = "수정"
    static let deleteTitle = "삭제"
    static let cancelTitle = "취소"
    static let continueTitle = "계속"
    static let confirmTitle = "확인"
    static let alertInputTitle = "password을 입력하세요."
    static let alertInputPlaceholder = "password 입력"
    static let wrongAlertTitle = "password가 일치하지 않습니다."
    static let wrongAlertMessage = "다시 시도해주세요."
  }
  
  private lazy var detailView = DetailView()
  private let httpProvider = HttpProvider()
  private var product: DetailProduct?
  private var pageId: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureDetailView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchDetailProductData { [weak self] in
      self?.configureNavigationBar()
      self?.setUpImage(of: self?.product?.images)
      self?.detailView.setUpDetailInformation(of: self?.product)
      self?.detailView.setScrollViewDelegate(delegate: self)
    }
  }
  
  func receiveInformation(for id: Int) {
    self.pageId = id
  }
  
  private func fetchDetailProductData(completionHandler: @escaping () -> Void) {
    guard let pageId = pageId else {
      return
    }
    let networkRequirements = HttpRequirements(
      endpoint: .productInformation(productId: pageId)
    )
  
    httpProvider.execute(networkRequirements) { data in
      guard let data = try? data.get() else {
        return
      }
      guard let selectedProduct = try? JSONDecoder().decode(DetailProduct.self, from: data)
      else {
        return
      }
      
      self.product = selectedProduct
      DispatchQueue.main.async {
        completionHandler()
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
    guard let product = product else {
      return
    }

    if product.venderId == Constants.venderId {
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: .action,
        target: self,
        action: #selector(presentActionSheet)
      )
    }
    
    self.navigationItem.title = self.product?.name
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
  }
  
  @objc private func presentActionSheet() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let deleteAction = UIAlertAction(
      title: Constants.deleteTitle,
      style: UIAlertAction.Style.destructive
    ) { [weak self] (_) in
      self?.presentPasswordInputAlert()
    }
    
    let cancelAction = UIAlertAction(
      title: Constants.cancelTitle,
      style: UIAlertAction.Style.cancel
    )
    
    alert.addAction(editAction)
    alert.addAction(deleteAction)
    alert.addAction(cancelAction)
    present(alert, animated: true)
  }
  
  private func presentEditingView() {
    let editingViewController = EditingViewController()
    let navigationController = UINavigationController(rootViewController: editingViewController)
    navigationController.modalPresentationStyle = .fullScreen
    editingViewController.receiveInformation(for: self.product)
    present(navigationController, animated: true, completion: nil)
  }
  
  private func checkSecretKey(
    _ inputPassword: String?,
    completionHandler: @escaping (String, Bool) -> Void
  ) {
    guard let pageId = self.pageId else {
      return
    }
    guard let inputPassword = inputPassword else {
      return
    }
    let networkRequirements = HttpRequirements(
      endpoint: .secretKey(productId: pageId, secret: inputPassword)
    )
    
    self.httpProvider.execute(networkRequirements) { result in
      switch result {
      case .success(let data):
        guard let reponseSecret = String(data: data, encoding: .utf8) else {
          return
        }
        completionHandler(reponseSecret, true)
      case .failure(let error):
        print(error)
        completionHandler(error.localizedDescription, false)
      }
    }
  }
  
  private func deleteData(_ secretKey: String) {
    guard let pageId = self.pageId else {
      return
    }
    let networkRequirements = HttpRequirements(
      endpoint: .delete(productId: pageId, productSecret: secretKey)
    )
    httpProvider.execute(networkRequirements) { result in
      switch result {
      case .success(_):
        return
      case .failure(let error):
        print(error)
      }
    }
  }
}

//MARK: - Alert
extension DetailViewController {
  private func presentPasswordInputAlert() {
    let alert = UIAlertController(
      title: Constants.alertInputTitle,
      message: nil,
      preferredStyle: .alert
    )
    
    alert.addTextField { textField in
      textField.placeholder = Constants.alertInputPlaceholder
      textField.returnKeyType = .continue
      textField.isSecureTextEntry = true
    }
    
    let continueAction = UIAlertAction(
      title: Constants.continueTitle,
      style: .default
    ) { [weak self] (_) in
      guard let passwordText = alert.textFields?.first?.text else {
        return
      }
      self?.checkSecretKey(passwordText) { (key, isVaild) in
        switch isVaild {
        case true:
          self?.deleteData(key)
          DispatchQueue.main.async {
            self?.navigationController?.popViewController(animated: true)
          }
        case false:
          DispatchQueue.main.async {
            self?.presentWrongPasswordAlert()
          }
        }
      }
    }
    
    let cancelAction = UIAlertAction(title: Constants.cancelTitle, style: .cancel)
    
    alert.addAction(cancelAction)
    alert.addAction(continueAction)
    
    present(alert, animated: true)
  }
  
  private func presentWrongPasswordAlert() {
    let alert = UIAlertController(
      title: Constants.wrongAlertTitle,
      message: Constants.wrongAlertMessage,
      preferredStyle: .alert
    )
    
    let confirmAction = UIAlertAction(
      title: Constants.confirmTitle,
      style: .cancel
    ) { [weak self] (_) in
      self?.presentPasswordInputAlert()
    }
    
    alert.addAction(confirmAction)
    
    present(alert, animated: false, completion: nil)
  }
  
  private func setUpImage(of images: [Image]?) {
    guard let images = images else {
      return
    }
    for index in 0..<images.count {
      let imageView = UIImageView()
      imageView.loadImage(urlString: images[index].url)
      imageView.contentMode = .scaleAspectFill
      detailView.addInScrollView(imageView, index)
    }
  }
}

extension DetailViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let xPosition = scrollView.contentOffset.x / scrollView.frame.width
    let pageNumber = Int(round(xPosition))
    detailView.setCurrentPage(pageNumber)
  }
}
