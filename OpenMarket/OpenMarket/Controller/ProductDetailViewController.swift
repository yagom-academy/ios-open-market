//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by 김동용 on 2022/07/27.
//

import UIKit

class ProductDetailViewController: UIViewController {
    let productDetailView = ProductDetailView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        view.addSubview(productDetailView)
        setConstraints()
//        self.view = productDetailView
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            productDetailView.topAnchor.constraint(equalTo: self.view.topAnchor),
            productDetailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            productDetailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productDetailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

