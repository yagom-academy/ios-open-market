//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by parkhyo on 2022/12/08.
//

import UIKit

final class DetailViewController: UIViewController {

    var productData: [Product] = []
    var cellImages: [UIImage] = []
    let detailView = DetailProductView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = detailView
        setupNavigationBar()
        setupData()
    }

    private func setupData() {
        // UIComponent에 productData 바인딩
        
    }
    
    private func setupNavigationBar() {
        self.title = productData.first?.name
        
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        let optionBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProduct))
        
        self.navigationItem.rightBarButtonItem = optionBarButton
    }
    
    @objc func editProduct() {
        print(productData)
        showEditAlert()
    }
}

extension DetailViewController {
    func showEditAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let editAction = UIAlertAction(title: "수정", style: .default) { _ in
            let modifyViewController = ModifyViewController()
            modifyViewController.productData = self.productData
            modifyViewController.setupOriginProductData(product: self.productData.first!)
            self.navigationController?.pushViewController(modifyViewController, animated: true)
        }
        
        let deleteAction = UIAlertAction(title: "삭제", style: .default) { _ in
            //서버에 삭제 메서드 보냄
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
