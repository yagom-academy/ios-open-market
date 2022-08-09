//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/09.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    private var productID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = productID
    }
}

extension ProductDetailViewController: Datable {
    func setupProduct(id: String) {
        productID = id
    }
}
