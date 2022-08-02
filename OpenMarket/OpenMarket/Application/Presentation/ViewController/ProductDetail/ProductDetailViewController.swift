//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by Derrick kim on 2022/07/27.
//

import UIKit

class ProductDetailViewController: UIViewController {
    private var productDetailsAPIManager: ProductDetailsAPIManager?
    var productID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        fetchProductDetails(by: productID)
    }
    
    private func fetchProductDetails(by productID: Int) {
        productDetailsAPIManager = ProductDetailsAPIManager(productID: productID.description
        )
        productDetailsAPIManager?.requestAndDecodeProduct(dataType: ProductDetail.self) { result in
            switch result {
            case .success(let data):
                print(data)
                break
            case .failure(_):
                break
            }
        }
    }
}
