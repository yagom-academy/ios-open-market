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
                guard let result = result as? ProductDetail else { return }
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
        
        let delete = UIAlertAction(title: Alert.delete, style: .destructive) {_ in
            let alert = UIAlertController(title: "상품 삭제", message: "비밀번호 입력", preferredStyle: .alert)
            let delete = UIAlertAction(title: "삭제", style: .destructive) {_ in
                guard let secret = alert.textFields?.first?.text else {
                    return
                }
                self.checkPassword(secret: secret) { result in
                    switch result {
                    case .success(let secret):
                        self.executeDELETE(secret: secret)
                    case .failure(_):
                        DispatchQueue.main.async {
                            self.showWrongPasswordAlert()
                        }
                    }
                }
            }
            
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addTextField { passwordTextField in
                passwordTextField.placeholder = "비밀번호를 입력하세요"
            }
            
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        
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

extension ProductDetailViewController {
    private func checkPassword(secret: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        guard let productId = products.id else {
            return
        }
        
        self.networkManager.execute(with: .productSecretCheck(productId: productId), httpMethod: .secretPost, secret: secret) { result in
            switch result {
            case .success(let secret):
                guard let data = secret as? Data else {
                    return
                }
                
                guard let secret = String(data: data, encoding: .utf8) else {
                    return
                }
                
                completionHandler(.success(secret))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    @objc private func executeDELETE(secret: String) {
        guard let productId = products.id else {
            return
        }
        
        self.networkManager.execute(with: .productDelete(productId: productId, secret: secret), httpMethod: .delete) {
            result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.showSuccessAlert()
                }
            case .failure:
                DispatchQueue.main.async {
                    self.showFailureAlert()
                }
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "삭제 성공", message: "상품을 삭제했습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alert.ok, style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    private func showFailureAlert() {
        let alert = UIAlertController(title: "삭제 실패", message: "상품을 삭제하지 못했습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alert.ok, style: .default))
        self.present(alert, animated: true)
    }
    
    private func showWrongPasswordAlert() {
        let alert = UIAlertController(title: "비밀번호 불일치", message: "비밀번호가 틀렸습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
