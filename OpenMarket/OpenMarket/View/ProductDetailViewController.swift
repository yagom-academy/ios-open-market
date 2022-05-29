//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by marisol on 2022/05/28.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    var id: Int?
    private var productDetail: ProductDetail?
    private var networkManager = NetworkManager<ProductDetail>(session: URLSession.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureBarButton()
        executeGET()
    }
    
    func configureBarButton() {
        let editButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(editButtonDidTapped))
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    private func executeGET() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        DispatchQueue.global().async(group: dispatchGroup) {
            guard let id = self.id else {
                return
            }
            self.networkManager.execute(with: .productEdit(productId: id), httpMethod: .get) { result in
                switch result {
                case .success(let result):
                    self.productDetail = result
                    dispatchGroup.leave()
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
}
