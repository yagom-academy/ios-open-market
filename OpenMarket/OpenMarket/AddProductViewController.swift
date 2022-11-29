//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/23.
//

import UIKit

final class AddProductViewController: UIViewController {
    private let leftButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "Cancel"
        return barButton
    }()
    
    private let rightButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "Done"
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        addTarget()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "상품등록"
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func addTarget() {
        leftButton.action = #selector(tapCancelButton)
        leftButton.target = self
        rightButton.action = #selector(tapDoneButton)
        rightButton.target = self
    }
    
    @objc private func tapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func tapDoneButton() {
        dismiss(animated: true)
    }
}
