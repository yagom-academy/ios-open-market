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
                                             target: nil,
                                             action: #selector(updateProducts))
        self.navigationItem.title = Design.navigationItemTitle
        self.navigationItem.setRightBarButton(rightBarButton,
                                              animated: true)
    }
    
    // MARK: - @objc functions
    
    @objc private func updateProducts() {
        navigationController?.popViewController(animated: true)
    }
}

private enum Design {
    static let navigationItemTitle = "상품수정"
}
