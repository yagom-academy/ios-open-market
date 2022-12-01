//
//  RegistrationViewController.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/12/01.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let button = UIBarButtonItem(title: "Done",
                                     style: .plain,
                                     target: self,
                                     action: #selector(registerProduct))
        
        navigationItem.title = "상품등록"
        navigationItem.rightBarButtonItem  = button
    }
    
    @objc func registerProduct() {
    }
    
}
