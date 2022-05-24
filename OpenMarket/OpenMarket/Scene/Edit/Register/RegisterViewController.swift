//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/24.
//

import UIKit

final class RegisterViewController: UIViewController {
    lazy var editView = EditView(frame: view.frame)
    
    override func loadView() {
        super.loadView()
        view = editView
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setUpBarItems()
    }
    
    private func setUpBarItems() {
        editView.setUpBarItem(title: "상품등록")
        editView.navigationBarItem.leftBarButtonItem?.target = self
        editView.navigationBarItem.leftBarButtonItem?.action = #selector(didTapCancelButton)
    }
    
    @objc private func didTapCancelButton() {
        self.dismiss(animated: true)
    }
}
