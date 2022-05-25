//
//  RegisterProductViewController.swift
//  OpenMarket
//
//  Created by papri, Tiana on 18/05/2022.
//

import UIKit

class RegisterProductViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        setUpNavigationItem()
    }
    
    private func setUpNavigationItem() {
        navigationItem.title = "상품등록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(touchUpDoneButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(touchUpCancelButton))
    }
    
    @objc private func touchUpDoneButton() {
        dismiss(animated: true)
    }
    
    @objc private func touchUpCancelButton() {
        dismiss(animated: true)
    }
    
}
