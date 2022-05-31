//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/28.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    private let products: Products
    private var productDetail: ProductDetail?
    private var networkManager = NetworkManager<ProductDetail>(session: URLSession.shared)
    private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelButtonDidTapped(_:)))
    
    init(products: Products) {
        self.products = products
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        configureBarButton()
        executeGET()
    }
    
    private func setView() {
        self.view.backgroundColor = .white
    }
    
    private func configureBarButton() {
        let editButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(editButtonDidTapped))
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.backBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    private func executeGET() {
        guard let id = self.products.id else {
            return
        }
        
        self.networkManager.execute(with: .productEdit(productId: id), httpMethod: .get) { result in
            switch result {
            case .success(let result):
                self.productDetail = result
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func editButtonDidTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: Alert.edit, style: .default) {_ in
            guard let productDetail = self.productDetail else {
                return
            }
            
            let productEditViewController = ProductEditViewController(productDetail: productDetail)

            self.navigationController?.pushViewController(productEditViewController, animated: true)
        }
        
        let delete = UIAlertAction(title: Alert.delete, style: .destructive, handler: nil)
        
        let cancel = UIAlertAction(title: Alert.cancel, style: .cancel) {_ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(edit)
        alertController.addAction(delete)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func cancelButtonDidTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
