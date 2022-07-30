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
        self.view.backgroundColor = .white
        view.addSubview(productUpdateView)
        setUpConstraints()
        setUpNavigation()
    }
    
    func setUpNavigation() {
        navigationItem.title = "상품수정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(updateProducts))
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            productUpdateView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5),
            productUpdateView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5),
            productUpdateView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            productUpdateView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5)
        ])
    }
    
    private func setUpNavigationController() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: nil,
                                             action: #selector(updateProducts))
        self.navigationItem.title = "상품수정"
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    // MARK: - @objc functions
    
    @objc private func updateProducts() {
        productUpdateView.update()
        navigationController?.popViewController(animated: true)
    }
}
