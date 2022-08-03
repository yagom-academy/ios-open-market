//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/08/03.
//

import Foundation
import UIKit

final class ProductDetailViewController: UIViewController {
    var productId: Int?
    var viewControllerTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(setupBarButtonTap))
        navigationItem.title = self.viewControllerTitle
    }
    
    // MARK: - @objc method
    @objc private func setupBarButtonTap() {
        let rightBarButtonActionSheet = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
        
        let updateAction = UIAlertAction(title: "수정", style: .default) { [weak self]_ in
            print("Tapped update action")
            self?.presentSetupViewController()
        }
        let removeAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self]  _ in
            print("Tapped remove action")
            self?.deleteCheck()
        }
        rightBarButtonActionSheet.addAction(updateAction)
        rightBarButtonActionSheet.addAction(removeAction)
        rightBarButtonActionSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(rightBarButtonActionSheet, animated: true)
    }
    
    private func presentSetupViewController() {
        let setupViewController = ProductSetupViewController()
        setupViewController.productId = self.productId
        setupViewController.viewControllerTitle = self.viewControllerTitle
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
                //삭제 로직 여기에 추가
                // 삭제 실패시 오류 띄우기
                // - 코드 
                //삭제 정상처리시
                self.showAlert(title: "삭제 성공!", message: "메인메뉴로"){
                    self.navigationController?.popViewController(animated: true)
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

