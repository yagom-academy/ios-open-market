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
    
    enum Constant: String {
        case uploadSuccessText = "상품 업로드 성공"
        case uploadSuccessMessage = "등록 성공하였습니다."
        case failureMessage = "상품 업로드에 실패했습니다."
        case confirmMessage = "입력을 확인해주세요."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupData() -> Result<NewProduct, DataError> {
        guard let name = showView.nameTextField.text,
              let description = showView.descriptionTextView.text,
              let priceString = showView.priceTextField.text,
              let price = Double(priceString) else { return Result.failure(.none) }
        
        var newProduct = NewProduct(name: name, productID: nil,
                                    description: description,
                                    currency: showView.currency,
                                    price: price)
        
        if showView.salePriceTextField.text != nil {
            guard let salePriceString = showView.salePriceTextField.text else { return Result.failure(.none) }
            newProduct.discountedPrice = Double(salePriceString)
        }
        if showView.stockTextField.text != nil {
            guard let stock = showView.stockTextField.text else { return Result.failure(.none) }
            newProduct.stock = Int(stock)
        }
        
        return Result.success(newProduct)
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
        
    }
}
