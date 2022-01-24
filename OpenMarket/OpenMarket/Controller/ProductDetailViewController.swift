//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/24.
//

import UIKit

class ProductDetailViewController: UIViewController, ReuseIdentifying {
  
  var product: Product?
  private var images: [UIImage]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = product?.name
  }
  

}
