//
//  ProductSetupViewController.swift
//  OpenMarket
//
//  Created by 이원빈 on 2022/07/28.
//

import UIKit

class ProductSetupViewController: UIViewController {

    var productSetupView: ProductSetupView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        productSetupView = ProductSetupView(self)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTapped))
    }
    
    @objc func cancelButtonDidTapped() {
        
    }
    
    @objc func doneButtonDidTapped() {
        
    }
}
