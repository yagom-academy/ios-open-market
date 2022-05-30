//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/30.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    private var mainView: ProductDetailView?
    private let product: Product
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        mainView = ProductDetailView(frame: view.bounds)
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView?.backgroundColor = .systemBackground
        mainView?.configure(data: product)
    }
}
