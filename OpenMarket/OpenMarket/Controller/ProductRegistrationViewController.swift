//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by song on 2022/05/25.
//

import UIKit

final class ProductRegistrationViewController: UIViewController {
    private lazy var baseView = ProductRegistrationView(frame: view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupView()
    }
    
    private func setupView() {
        view = baseView
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationItems() {
        self.navigationItem.title = "상품등록"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneButton))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func didTapCancelButton() {
        self.navigationController?.dismiss(animated: true)
    }
    
    @objc private func didTapDoneButton() { }
}
