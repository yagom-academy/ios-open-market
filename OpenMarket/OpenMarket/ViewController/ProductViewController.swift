//
//  ProductViewController.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/26.
//

import UIKit

class ProductViewController: UIViewController {
    lazy var productView = ProductView(frame: view.frame)
    
    var currency: Currency = .KRW
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = productView
        self.view.backgroundColor = .white
        defineTextFieldDelegate()
        productView.currencyField.addTarget(self, action: #selector(changeCurrency(_:)), for: .valueChanged)
        productView.currencyField.selectedSegmentIndex = currency.value
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.productView.mainScrollView.contentSize = .init(width: self.productView.mainScrollView.frame.width, height: self.productView.mainScrollView.frame.height + keyboardSize.height - 140)
            
            if self.productView.descriptionView.isFirstResponder {
                productView.mainScrollView.scrollRectToVisible(productView.descriptionView.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.productView.mainScrollView.contentSize = .init(width: self.productView.mainScrollView.frame.width, height: self.productView.mainScrollView.frame.height - keyboardSize.height + 140)
        }
    }
    
    @objc func changeCurrency(_ sender: UISegmentedControl) {
        let mode = sender.selectedSegmentIndex
        if mode == Currency.KRW.value {
            currency = Currency.KRW
        } else if mode == Currency.USD.value {
            currency = Currency.USD
        }
    }
    
    @objc private func cancelRequest(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func defineTextFieldDelegate() {
        productView.priceField.delegate = self
        productView.discountedPriceField.delegate = self
        productView.stockField.delegate = self
    }
    
    func setUpNavigationBar() {
        self.navigationItem.hidesBackButton = true
        let cancelbutton = UIBarButtonItem(title: OpenMarketConstant.cancel, style: .plain, target: self, action: #selector(cancelRequest))
        cancelbutton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.preferredFont(for: .body, weight: .semibold)], for: .normal)
        self.navigationItem.leftBarButtonItem = cancelbutton
    }
}

extension ProductViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if Int(string) != nil || string == OpenMarketConstant.emptyString {
            return true
        }
        
        return false
    }
}
