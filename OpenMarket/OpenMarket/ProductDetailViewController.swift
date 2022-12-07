//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/12/07.
//

import UIKit

class ProductDetailViewController: UIViewController {
    private let detailProduct: DetailProduct

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
    }
    
    init(_ detailProduct: DetailProduct) {
        self.detailProduct = detailProduct
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
