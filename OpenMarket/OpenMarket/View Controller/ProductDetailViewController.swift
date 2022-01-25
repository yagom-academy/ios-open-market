//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/21.
//

import UIKit

class ProductDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editProductView = segue.destination as? EditProductViewController {
            editProductView.productNavigationBar.title = "상품수정"
        }
    }
}
