//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/28.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    var id: Int?
    private var productDetail: ProductDetail?
    private var networkManager = NetworkManager<ProductDetail>(session: URLSession.shared)
    private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelButtonDidTapped(_:)))
    
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
        DispatchQueue.global().async {
            guard let id = self.id else {
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
    }
    
    @objc func editButtonDidTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "수정", style: .default) {_ in
            let productEditViewController = ProductEditViewController()
            productEditViewController.productDetail = self.productDetail
            self.navigationController?.pushViewController(productEditViewController, animated: true)
        }
        
        let delete = UIAlertAction(title: "삭제", style: .destructive, handler: nil)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) {_ in
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
