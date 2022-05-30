//
//  EditingViewController.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

final class EditingViewController: UIViewController {
  private enum Constants {
    static let navigationBarTitle = "상품수정"
    static let warningAlertTitle = "입력하지 않은 정보가 있습니다."
    static let warningAlertMessage = "입력 정보를 확인해주세요."
    static let warningAlertCancelText = "확인"
  }
  
  private var apiProvider = HttpProvider()
  private lazy var editingView = EditingView()
  private var detailProduct: DetailProduct?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureRegistrationView()
    configureView()
  }
  
  func receiveImformation(for detailProduct: DetailProduct?) {
    self.detailProduct = detailProduct
  }
  
  private func configureRegistrationView() {
    let safeArea = self.view.safeAreaLayoutGuide
    self.view.addSubview(editingView)
    
    NSLayoutConstraint.activate([
      editingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      editingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      editingView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      editingView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
    
    configureNavigationBar()
  }
  
  private func configureView() {
    guard let product = detailProduct else {
      return
    }
    editingView.displayInformation(of: product)
    configureImageView(with: product.images)
  }
  
  private func configureImageView(with images: [Image]) {
    for image in images {
      let imageView = UIImageView()
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
      imageView.loadImage(urlString: image.url)
      editingView.imageStackView.addArrangedSubviews(imageView)
    }
  }
  
  private func configureNavigationBar() {
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(cancelModal))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                             target: self,
                                                             action: #selector(postEditedData))
    self.navigationItem.title = Constants.navigationBarTitle
    
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
  }
  
  @objc private func cancelModal() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc private func postEditedData() {
    let params = editingView.setupParams()
    let group = DispatchGroup()
    guard let product = self.detailProduct else {
      return
    }
    
    guard let params = params else {
      presentWarningAlert()
      return
    }
    
    DispatchQueue.global().async(group: group) {
      self.apiProvider.patch(.editing(productId: product.id), params) { result in
        switch result {
        case .success(_):
          return
        case .failure(let response):
          print(response)
          return
        }
      }
    }
    group.notify(queue: .main) {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  private func presentWarningAlert() {
    let alert = UIAlertController(title: Constants.warningAlertTitle,
                                  message: Constants.warningAlertMessage, preferredStyle: .alert)
    let cancel = UIAlertAction(title: Constants.warningAlertCancelText,
                               style: .cancel, handler: nil)
    
    alert.addAction(cancel)
    
    present(alert, animated: true, completion: nil)
  }
}
