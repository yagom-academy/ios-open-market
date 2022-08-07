//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/08/03.
//

import Foundation
import UIKit

final class ProductDetailViewController: UIViewController {
    var productDetailView: ProductDetailView?
    var viewControllerInfo = ViewControllerInfo()
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupNavigationItem()
        productDetailView = ProductDetailView(self)
        productDetailView?.horizontalScrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let productId = viewControllerInfo.productId else {
            return
        }
        NetworkManager.shared.requestProductDetail(at: productId) { detail in
            DispatchQueue.main.async { [weak self] in
                self?.updateSetup(with: detail)
            }
        }
    }
    // MARK: - VC Method
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(setupBarButtonTap))
        navigationItem.title = viewControllerInfo.viewControllerTitle
    }
    
    private func updateSetup(with detail: ProductDetail) {
        guard let productDetailView = productDetailView else { return }
        detail.images.forEach { image in
            let imageView = ProductImageView(width: Int(self.view.frame.width) - 20, height: Int(self.view.frame.width*0.7))
            imageView.setImageUrl(image.url)
            imageView.contentMode = .scaleAspectFit
            productDetailView.horizontalStackView.addArrangedSubview(imageView)
        }
        productDetailView.update(with: detail)
    }
    
    // MARK: - @objc method
    @objc private func setupBarButtonTap() {
        let rightBarButtonActionSheet = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
        
        let updateAction = UIAlertAction(title: "수정", style: .default) { [weak self]_ in
            self?.presentSetupViewController()
        }
        let removeAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self]  _ in
            self?.deleteCheck()
        }
        rightBarButtonActionSheet.addAction(updateAction)
        rightBarButtonActionSheet.addAction(removeAction)
        rightBarButtonActionSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(rightBarButtonActionSheet, animated: true)
    }
    // MARK: - ProductSetupVC - Private method
    private func presentSetupViewController() {
        let setupViewController = ProductSetupViewController()
        setupViewController.viewControllerInfo.productId = viewControllerInfo.productId
        setupViewController.viewControllerInfo.viewControllerTitle = viewControllerInfo.viewControllerTitle
        navigationController?.pushViewController(setupViewController, animated: true)
    }
    
    private func deleteCheck() {
        let deleteCheckAlert = UIAlertController(title: "삭제", message: "비밀번호를 입력하십시오", preferredStyle: .alert)
        deleteCheckAlert.addTextField()
        deleteCheckAlert.addAction(UIAlertAction(title:  "입력", style: .default, handler: { UIAlertAction in
            guard let inputKey = deleteCheckAlert.textFields?.first?.text else {
                return
            }
            if inputKey == URLData.secret {
                guard let productId = self.viewControllerInfo.productId else {
                    return
                }
                NetworkManager.shared.requestProductDeleteKey(id: productId) { key in
                    NetworkManager.shared.requestProductDelete(id: productId, key: key) { detail in
                        DispatchQueue.main.async {
                            self.showAlert(title: "삭제 성공!", message: "메인메뉴로"){
                                self.navigationController?.popViewController(animated: true)
                                NotificationCenter.default.post(name: .refresh, object: nil)
                            }
                        }
                    }
                }
            } else {
                self.showAlert(title: "비번틀림", message: "다시입력하세요") {
                    self.deleteCheck()
                }
            }
        }))
        deleteCheckAlert.addAction(UIAlertAction(title: "취소", style: .destructive))
        present(deleteCheckAlert, animated: true)
    }
    
    private func showAlert(title: String, message: String, _ completion: (() -> Void)? = nil) {
        let failureAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            guard let completion = completion else { return }
            completion()
        }
        failureAlert.addAction(confirmAction)
        present(failureAlert, animated: true)
    }
}

extension ProductDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            guard let productDetailView = productDetailView else { return }
            let imageWidth = self.view.frame.width - 20
            let totalPage = productDetailView.horizontalStackView.bounds.width / imageWidth
            let currentPage = round(productDetailView.horizontalScrollView.contentOffset.x / imageWidth)
            productDetailView.pagingLabel.text = "\(Int(currentPage) + 1)/\(Int(totalPage))"
    }
}

