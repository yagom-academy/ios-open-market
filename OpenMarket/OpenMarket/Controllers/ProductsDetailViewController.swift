//
//  ProductsDetailViewController.swift
//  OpenMarket
//
//  Created by 이은찬 on 2022/07/26.
//

import UIKit

class ProductsDetailViewController: UIViewController {

    let imagePicker = UIImagePickerController()
    
    override func loadView() {
        view = ProductDetailView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "상품등록"
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        guard let detailView = view as? ProductDetailView else { return }
        detailView.button.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)
        
        addNavigationBarButton()
    }

    @objc func addButtonDidTapped() {
        present(imagePicker, animated: true)
    }
    
    func addNavigationBarButton() {
        navigationController?.navigationBar.topItem?.title = "Cancel"
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
    }
}

extension ProductsDetailViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
}
