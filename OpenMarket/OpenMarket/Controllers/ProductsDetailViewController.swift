//
//  ProductsDetailViewController.swift
//  OpenMarket
//
//  Created by LeeChiheon on 2022/08/01.
//

import UIKit

class ProductsDetailViewController: UIViewController {

    let detailView = ProductsDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
        
    }

}
