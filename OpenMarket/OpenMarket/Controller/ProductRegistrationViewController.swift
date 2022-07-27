//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/27.
//

import UIKit

class ProductRegistrationViewController: UIViewController {
    let productDetailView = ProductRegistrationView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        view.addSubview(productDetailView)
        productDetailView.translatesAutoresizingMaskIntoConstraints = false
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            productDetailView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5),
            productDetailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5),
            productDetailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            productDetailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5)
        ])
    }
}

