//
//  ProductViewController.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/12/03.
//

import UIKit

class ProductViewController: UIViewController {
    let networkManager = NetworkManager()
    var showView: ProductView {
        return ProductView()
    }
    var cellImages: [UIImage?] = []
    
    private enum Constant: String {
        case uploadSuccessText = "상품 업로드 성공"
        case uploadSuccessMessage = "등록 성공하였습니다."
        case failureMessage = "상품 업로드에 실패했습니다."
        case confirmMessage = "입력을 확인해주세요."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Forbid Override 
extension ProductViewController {
    func setupNavigationBar(title: String) {
        self.title = title
        let cancelButtonItem = UIBarButtonItem(title: "Cancel",
                                               style: .plain,
                                               target: self,
                                               action: #selector(cancelButtonTapped))
        let doneButtonItem = UIBarButtonItem(title: "Done",
                                             style: .plain,
                                             target: self,
                                             action: #selector(doneButtonTapped))
        
        self.navigationItem.leftBarButtonItem = cancelButtonItem
        self.navigationItem.rightBarButtonItem = doneButtonItem
    }
    
    @objc func cancelButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneButtonTapped() {
        let result = showView.setupData()
        switch result {
        case .success(let data):
            guard let postURL = NetworkRequest.postData.requestURL else { return }
            networkManager.postData(to: postURL,
                                    newData: (productData: data, images: cellImages)) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.showAlert(alertText: Constant.uploadSuccessText.rawValue,
                                       alertMessage: Constant.uploadSuccessMessage.rawValue) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(alertText: error.description,
                                       alertMessage: Constant.failureMessage.rawValue,
                                       completion: nil)
                    }
                }
            }
        case .failure(let error):
            self.showAlert(alertText: error.description,
                           alertMessage: Constant.confirmMessage.rawValue,
                           completion: nil)
        }
    }
}
