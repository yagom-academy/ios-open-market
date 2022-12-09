//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by 유제민 on 2022/12/09.
//

import UIKit

class ProductDetailViewController: UIViewController {
    var productData: ProductData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let image = UIImage(systemName: "square.and.arrow.up")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showActionSheet))
    }
}

extension ProductDetailViewController {
    @objc func showActionSheet() {
        
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "수정",
                                       style: .default) { _ in
            self.showEditViewController()
        }
        let deleteAction = UIAlertAction(title: "삭제",
                                         style: .destructive)
        let cancel = UIAlertAction(title: "취소",
                                   style: .cancel)
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func showEditViewController() {
        guard let product = productData else { return }
        let viewController = ProductEditViewController(product: product)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
