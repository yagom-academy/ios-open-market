//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/27.
//

import UIKit

class ProductRegistrationViewController: UIViewController {
    // MARK: - properties

    private let productRegistrationView = ProductRegistrationView()
    
    // MARK: - functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productRegistrationView.delegate = self
        view.backgroundColor = .white
        view.addSubview(productRegistrationView)
        setupConstraints()
        setupNavigationController()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                productRegistrationView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
                productRegistrationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
                productRegistrationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
                productRegistrationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
            ])
    }
    
    private func setupNavigationController() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: nil,
                                             action: #selector(registerButtonDidTap))
        navigationItem.title = Design.navigationTitle
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    // MARK: - @objc functions
    
    @objc private func registerButtonDidTap() {
        productRegistrationView.registerProduct()
        navigationController?.popViewController(animated: true)
    }
}

extension ProductRegistrationViewController: ImagePickerDelegate {
    func pickImages(pikerController: UIImagePickerController) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        pikerController.sourceType = .photoLibrary
        pikerController.allowsEditing = true
        
        present(pikerController, animated: true, completion: nil)
    }
}

private enum Design {
    static let navigationTitle = "상품등록"
}
