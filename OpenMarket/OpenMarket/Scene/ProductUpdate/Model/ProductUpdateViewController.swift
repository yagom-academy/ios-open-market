//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/29.
//

import UIKit

class ProductUpdateViewController: UIViewController {
    // MARK: - properties
    
    private let productUpdateView = ProductUpdateView()
    
    // MARK: - functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        view.addSubview(productUpdateView)
        setupConstraints()
        setupNavigationController()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                productUpdateView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
                productUpdateView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
                productUpdateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
                productUpdateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
            ])
    }
    
    private func setupNavigationController() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(updateButtonDidTap))
        self.navigationItem.title = Design.navigationItemTitle
        self.navigationItem.setRightBarButton(rightBarButton,
                                              animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self,
                                                                action: #selector(cancelButtonDidTap))
    }
    
    // MARK: - @objc functions
    
    @objc private func updateButtonDidTap() {
        productUpdateView.patchProduct()
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func cancelButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - extensions

extension ProductUpdateViewController: DataSendable {
    func setupData<T>(_ data: T) {
        guard let product = data as? ProductDetail else { return }
        
        productUpdateView.setupViewItems(product: product)
    }
}

// MARK: - Design

private enum Design {
    static let navigationItemTitle = "상품수정"
}
