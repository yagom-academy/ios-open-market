//
//  EditingViewController.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

class EditingViewController: UIViewController {
  private var apiProvider = ApiProvider<ProductsList>()
  private lazy var editingView = EditingView()
  var delegate: DetailProduct?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureRegistration()
    configureNavigationBar()
    configureView()
  }
  
  private func configureRegistration() {
    let safeArea = self.view.safeAreaLayoutGuide
    self.view.addSubview(editingView)
    
    NSLayoutConstraint.activate(
      [editingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
       editingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
       editingView.topAnchor.constraint(equalTo: safeArea.topAnchor),
       editingView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
      ])
  }
  
  private func configureNavigationBar() {
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(cancelModal))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                             target: self,
                                                             action: #selector(postEditedData))
    self.navigationItem.title = "상품수정"
    
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
  }
  
  @objc private func cancelModal() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc private func postEditedData() {
    let params = editingView.setupParams()
    let group = DispatchGroup()
    guard let delegate = delegate else {
      return
    }

    DispatchQueue.global().async(group: group) {
      self.apiProvider.patch(.editing(productId: delegate.id), params) { result in
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
  
  private func configureView() {
    guard let product = delegate else {
      return
    }
    editingView.displayProductInformation(product)
    loadImage(product.images)
  }
  
  private func loadImage(_ images: [Image]) {
    for image in images {
      let imageView = UIImageView()
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1).isActive = true
      imageView.loadImage(urlString: image.url)
      editingView.imageStackView.addArrangedSubviews(imageView)
    }
  }
}
