//
//  OpenMarket - ProductEditViewController.swift
//  Created by Zhilly, Dragon. 22/12/02
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ProductEditViewController: UIViewController {
    @IBOutlet weak var mainView: ProductChangeView!
    
    override func loadView() {
        super.loadView()
        mainView.titleLabel.text = "상품 수정"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
