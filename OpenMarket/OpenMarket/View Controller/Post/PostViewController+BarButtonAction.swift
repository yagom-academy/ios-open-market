//
//  PostViewController+BarButtonAction.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/28.
//

import UIKit

// MARK: Bar Button Action(Cancel, Post)
extension PostViewController {
    @IBAction func backToListView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postProduct(_ sender: Any) {
        let checkValidate: Result<ProductParams, ViewControllerError> = checkValidData()
        let urlSessionProvider = URLSessionProvider()
        
        // remove PlusButtonImage
        if tryAddImageCount < 5 {
            images.removeLast()
        }
        
        switch checkValidate {
        case .success(let data):
            urlSessionProvider.postData(requestType: .productRegistration, params: data, images: self.images) { (result: Result<Data, NetworkError>) in
                switch result {
                case .success(_):
                    self.goToPreviousView(title: "업로드 성공", "제품 리스트 화면으로 이동합니다")
                case .failure(let error):
                    self.alertError(error)
                }
            }
        case .failure(let error):
            self.alertError(error)
        }
    }
}

extension PostViewController {
    func checkValidData() -> Result<ProductParams, ViewControllerError> {
        guard let name = productNameTextField.text else {
            return .failure(.invalidInput)
        }
        
        guard name.count >= 3 else {
            return .failure(.invalidInput)
        }
        
        guard let priceTextfieldText = priceTextField.text else {
            return .failure(.invalidInput)
        }
        
        guard let price = Double(priceTextfieldText) else {
            return .failure(.invalidInput)
        }
        
        var currency = Currency.KRW
        let currencyIndex = currencySelectButton.selectedSegmentIndex
        switch currencyIndex {
        case 0:
            currency = Currency.KRW
        case 1:
            currency = Currency.USD
        default:
            return .failure(.invalidInput)
        }
        
        guard let discount = Double(bargainPriceTextField.text ?? "0") else {
            return .failure(.invalidInput)
        }
        
        let bargainPrice = price - discount
        
        guard let stock = Int(stockTextField.text ?? "0") else {
            return .failure(.invalidInput)
        }
        
        guard let description = descriptionTextView.text else {
            return .failure(.invalidInput)
        }
        
        return .success(ProductParams(name: name,
                                      descriptions: description,
                                      price: price,
                                      currency: currency,
                                      discountedPrice: bargainPrice,
                                      stock: stock,
                                      secret: "c8%MC*3wjXJ?Wf+g"))
    }
}
