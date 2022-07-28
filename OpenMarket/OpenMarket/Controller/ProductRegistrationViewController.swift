//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/27.
//

import UIKit

class ProductRegistrationViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    // MARK: - properties

    private let productRegistrationView = ProductRegistrationView()
    
    // MARK: - functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        productRegistrationView.delegate = self
        view.addSubview(productRegistrationView)
        productRegistrationView.translatesAutoresizingMaskIntoConstraints = false
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            productRegistrationView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5),
            productRegistrationView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5),
            productRegistrationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            productRegistrationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5)
        ])
    }
    
    private func setUpNavigationController() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: nil,
                                             action: #selector(printDone))
        self.navigationItem.title = "상품등록"
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    // MARK: - @objc functions
    
    @objc func printDone() {
        print("done")
    }
}

extension ProductRegistrationViewController: ImagePickerDelegate {
    @objc func pickImages() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
}
